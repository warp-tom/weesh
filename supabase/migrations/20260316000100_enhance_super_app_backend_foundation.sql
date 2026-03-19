create schema if not exists private;
revoke all on schema private from public;
revoke all on schema private from anon;
revoke all on schema private from authenticated;

do $$
begin
  if not exists (
    select 1 from pg_type t join pg_namespace n on n.oid = t.typnamespace
    where n.nspname = 'public' and t.typname = 'transaction_direction_enum'
  ) then
    create type public.transaction_direction_enum as enum ('credit', 'debit');
  end if;

  if not exists (
    select 1 from pg_type t join pg_namespace n on n.oid = t.typnamespace
    where n.nspname = 'public' and t.typname = 'weesh_event_type_enum'
  ) then
    create type public.weesh_event_type_enum as enum (
      'created',
      'accepted',
      'arrived_pickup',
      'started',
      'completed',
      'cancelled',
      'status_changed',
      'note'
    );
  end if;

  if not exists (
    select 1 from pg_type t join pg_namespace n on n.oid = t.typnamespace
    where n.nspname = 'public' and t.typname = 'complaint_category_enum'
  ) then
    create type public.complaint_category_enum as enum (
      'service',
      'driver',
      'parcel',
      'grocery',
      'wallet',
      'safety',
      'other'
    );
  end if;

  if not exists (
    select 1 from pg_type t join pg_namespace n on n.oid = t.typnamespace
    where n.nspname = 'public' and t.typname = 'complaint_status_enum'
  ) then
    create type public.complaint_status_enum as enum (
      'open',
      'investigating',
      'resolved',
      'closed'
    );
  end if;
end
$$;

create or replace function public.current_app_role()
returns text
language sql
stable
set search_path = public
as $$
  select coalesce(
    auth.jwt() -> 'app_metadata' ->> 'role',
    auth.jwt() -> 'user_metadata' ->> 'role',
    'user'
  );
$$;

create or replace function private.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.current_app_role() = 'admin';
$$;

create or replace function private.can_access_weesh(p_weesh_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    coalesce((select private.is_admin()), false)
    or exists (
      select 1
      from public.weeshes w
      where w.id = p_weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
        )
    );
$$;

alter table public.users
  add column if not exists preferred_mode text not null default 'customer',
  add column if not exists city text,
  add column if not exists province text;

alter table public.users
  drop constraint if exists users_preferred_mode_check;

alter table public.users
  add constraint users_preferred_mode_check
  check (preferred_mode in ('customer', 'driver'));

alter table public.drivers
  add column if not exists rating_avg numeric(3,2) not null default 5.00,
  add column if not exists rating_count integer not null default 0,
  add column if not exists last_seen_at timestamptz;

alter table public.weeshes
  add column if not exists request_code text,
  add column if not exists service_code text,
  add column if not exists pickup_label text,
  add column if not exists dropoff_label text,
  add column if not exists notes text,
  add column if not exists scheduled_for timestamptz,
  add column if not exists accepted_at timestamptz,
  add column if not exists started_at timestamptz,
  add column if not exists completed_at timestamptz,
  add column if not exists cancelled_at timestamptz,
  add column if not exists cancelled_by uuid references public.users(id) on delete set null,
  add column if not exists metadata jsonb not null default '{}'::jsonb;

alter table public.transactions
  add column if not exists direction public.transaction_direction_enum;

update public.transactions
set direction = case
  when kind in ('wallet_topup', 'refund', 'adjustment') then 'credit'::public.transaction_direction_enum
  else 'debit'::public.transaction_direction_enum
end
where direction is null;

create table if not exists public.wallet_accounts (
  user_id uuid primary key references public.users(id) on delete cascade,
  currency text not null default 'PHP',
  available_balance numeric(12,2) not null default 0,
  pending_balance numeric(12,2) not null default 0,
  lifetime_credits numeric(12,2) not null default 0,
  lifetime_debits numeric(12,2) not null default 0,
  last_transaction_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.weesh_events (
  id uuid primary key default extensions.uuid_generate_v4(),
  weesh_id uuid not null references public.weeshes(id) on delete cascade,
  actor_user_id uuid references public.users(id) on delete set null,
  event_type public.weesh_event_type_enum not null,
  title text not null,
  description text,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.weesh_ratings (
  id uuid primary key default extensions.uuid_generate_v4(),
  weesh_id uuid not null references public.weeshes(id) on delete cascade,
  rater_user_id uuid not null references public.users(id) on delete cascade,
  rated_user_id uuid not null references public.users(id) on delete cascade,
  score integer not null check (score between 1 and 5),
  comment text,
  tags text[] not null default '{}'::text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (weesh_id, rater_user_id, rated_user_id)
);

create table if not exists public.weesh_complaints (
  id uuid primary key default extensions.uuid_generate_v4(),
  weesh_id uuid references public.weeshes(id) on delete set null,
  reporter_user_id uuid not null references public.users(id) on delete cascade,
  reported_user_id uuid references public.users(id) on delete set null,
  category public.complaint_category_enum not null default 'other',
  title text not null,
  description text not null,
  status public.complaint_status_enum not null default 'open',
  resolution_notes text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists wallet_accounts_updated_at_idx
  on public.wallet_accounts(updated_at desc);

create index if not exists weesh_events_weesh_created_at_idx
  on public.weesh_events(weesh_id, created_at desc);

create index if not exists weesh_events_actor_created_at_idx
  on public.weesh_events(actor_user_id, created_at desc);

create index if not exists weesh_ratings_rated_user_idx
  on public.weesh_ratings(rated_user_id, created_at desc);

create index if not exists weesh_complaints_reporter_idx
  on public.weesh_complaints(reporter_user_id, created_at desc);

create index if not exists weesh_complaints_status_idx
  on public.weesh_complaints(status, created_at desc);

create index if not exists weeshes_request_code_idx
  on public.weeshes(request_code);

create index if not exists weeshes_service_status_idx
  on public.weeshes(service_code, status, created_at desc);

create or replace function private.assign_weesh_request_code()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.request_code is null or btrim(new.request_code) = '' then
    new.request_code := 'WSH-' || upper(substr(replace(extensions.uuid_generate_v4()::text, '-', ''), 1, 10));
  end if;

  if new.metadata is null then
    new.metadata := '{}'::jsonb;
  end if;

  return new;
end;
$$;

create or replace function private.apply_weesh_status_timestamps()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    if new.status = 'accepted' and new.accepted_at is null then
      new.accepted_at := now();
    elsif new.status = 'in_progress' and new.started_at is null then
      new.started_at := now();
    elsif new.status = 'completed' and new.completed_at is null then
      new.completed_at := now();
    elsif new.status = 'cancelled' and new.cancelled_at is null then
      new.cancelled_at := now();
    end if;

    return new;
  end if;

  if old.status is distinct from new.status then
    if new.status = 'accepted' and new.accepted_at is null then
      new.accepted_at := now();
    elsif new.status = 'in_progress' and new.started_at is null then
      new.started_at := now();
    elsif new.status = 'completed' and new.completed_at is null then
      new.completed_at := now();
    elsif new.status = 'cancelled' and new.cancelled_at is null then
      new.cancelled_at := now();
    end if;
  end if;

  return new;
end;
$$;

create or replace function private.log_weesh_lifecycle_event()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  event_actor uuid;
  event_type_value public.weesh_event_type_enum;
  event_title text;
  event_description text;
begin
  event_actor := coalesce((select auth.uid()), new.driver_id, new.user_id);

  if tg_op = 'INSERT' then
    insert into public.weesh_events (weesh_id, actor_user_id, event_type, title, description, payload)
    values (
      new.id,
      event_actor,
      'created',
      'Weesh created',
      coalesce(new.pickup_label, 'Pickup assigned') || ' to ' || coalesce(new.dropoff_label, 'Dropoff assigned'),
      jsonb_build_object('status', new.status, 'type', new.type, 'service_code', new.service_code)
    );

    return new;
  end if;

  if old.status is distinct from new.status then
    event_type_value := case new.status
      when 'accepted' then 'accepted'::public.weesh_event_type_enum
      when 'in_progress' then 'started'::public.weesh_event_type_enum
      when 'completed' then 'completed'::public.weesh_event_type_enum
      when 'cancelled' then 'cancelled'::public.weesh_event_type_enum
      else 'status_changed'::public.weesh_event_type_enum
    end;

    event_title := case new.status
      when 'accepted' then 'Driver accepted the request'
      when 'in_progress' then 'Trip or task is now in progress'
      when 'completed' then 'Weesh completed'
      when 'cancelled' then 'Weesh cancelled'
      else 'Weesh status updated'
    end;

    event_description := 'Status changed from ' || old.status::text || ' to ' || new.status::text;

    insert into public.weesh_events (weesh_id, actor_user_id, event_type, title, description, payload)
    values (
      new.id,
      event_actor,
      event_type_value,
      event_title,
      event_description,
      jsonb_build_object('old_status', old.status, 'new_status', new.status)
    );
  end if;

  return new;
end;
$$;

create or replace function private.ensure_wallet_account()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.wallet_accounts (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

create or replace function private.assign_transaction_direction()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.direction is null then
    new.direction := case
      when new.kind in ('wallet_topup', 'refund', 'adjustment') then 'credit'::public.transaction_direction_enum
      else 'debit'::public.transaction_direction_enum
    end;
  end if;

  return new;
end;
$$;

create or replace function private.refresh_wallet_account(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.wallet_accounts (user_id)
  values (p_user_id)
  on conflict (user_id) do nothing;

  update public.wallet_accounts wa
  set
    available_balance = coalesce((
      select sum(case when t.direction = 'credit' then t.amount else -t.amount end)
      from public.transactions t
      where t.user_id = p_user_id
        and t.status = 'posted'
    ), 0),
    pending_balance = coalesce((
      select sum(case when t.direction = 'credit' then t.amount else -t.amount end)
      from public.transactions t
      where t.user_id = p_user_id
        and t.status = 'pending'
    ), 0),
    lifetime_credits = coalesce((
      select sum(t.amount)
      from public.transactions t
      where t.user_id = p_user_id
        and t.status = 'posted'
        and t.direction = 'credit'
    ), 0),
    lifetime_debits = coalesce((
      select sum(t.amount)
      from public.transactions t
      where t.user_id = p_user_id
        and t.status = 'posted'
        and t.direction = 'debit'
    ), 0),
    last_transaction_at = (
      select max(t.created_at)
      from public.transactions t
      where t.user_id = p_user_id
    ),
    updated_at = now()
  where wa.user_id = p_user_id;
end;
$$;

create or replace function private.handle_wallet_account_sync()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op in ('INSERT', 'UPDATE') then
    perform private.refresh_wallet_account(new.user_id);
  end if;

  if tg_op in ('UPDATE', 'DELETE') then
    perform private.refresh_wallet_account(old.user_id);
  end if;

  return coalesce(new, old);
end;
$$;

create or replace function private.refresh_driver_rating_summary(p_driver_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (select 1 from public.drivers d where d.id = p_driver_id) then
    return;
  end if;

  update public.drivers d
  set
    rating_avg = coalesce((
      select round(avg(r.score)::numeric, 2)
      from public.weesh_ratings r
      where r.rated_user_id = p_driver_id
    ), 5.00),
    rating_count = coalesce((
      select count(*)::integer
      from public.weesh_ratings r
      where r.rated_user_id = p_driver_id
    ), 0),
    last_seen_at = coalesce(d.last_seen_at, now())
  where d.id = p_driver_id;
end;
$$;

create or replace function private.handle_driver_rating_summary_sync()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op in ('INSERT', 'UPDATE') then
    perform private.refresh_driver_rating_summary(new.rated_user_id);
  end if;

  if tg_op in ('UPDATE', 'DELETE') then
    perform private.refresh_driver_rating_summary(old.rated_user_id);
  end if;

  return coalesce(new, old);
end;
$$;

create or replace function private.touch_driver_last_seen()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.is_online = true then
    new.last_seen_at := now();
  elsif new.current_location is distinct from old.current_location then
    new.last_seen_at := now();
  end if;

  return new;
end;
$$;

insert into public.wallet_accounts (user_id)
select u.id
from public.users u
on conflict (user_id) do nothing;

update public.weeshes
set request_code = 'WSH-' || upper(substr(replace(extensions.uuid_generate_v4()::text, '-', ''), 1, 10))
where request_code is null or btrim(request_code) = '';

update public.drivers
set last_seen_at = coalesce(last_seen_at, now())
where last_seen_at is null;

select private.refresh_wallet_account(u.id)
from public.users u;

drop trigger if exists weeshes_assign_request_code on public.weeshes;
create trigger weeshes_assign_request_code
before insert or update on public.weeshes
for each row execute function private.assign_weesh_request_code();

drop trigger if exists weeshes_apply_status_timestamps on public.weeshes;
create trigger weeshes_apply_status_timestamps
before insert or update on public.weeshes
for each row execute function private.apply_weesh_status_timestamps();

drop trigger if exists weeshes_log_lifecycle_event on public.weeshes;
create trigger weeshes_log_lifecycle_event
after insert or update on public.weeshes
for each row execute function private.log_weesh_lifecycle_event();

drop trigger if exists users_ensure_wallet_account on public.users;
create trigger users_ensure_wallet_account
after insert on public.users
for each row execute function private.ensure_wallet_account();

drop trigger if exists transactions_assign_direction on public.transactions;
create trigger transactions_assign_direction
before insert or update on public.transactions
for each row execute function private.assign_transaction_direction();

drop trigger if exists transactions_sync_wallet_account on public.transactions;
create trigger transactions_sync_wallet_account
after insert or update or delete on public.transactions
for each row execute function private.handle_wallet_account_sync();

drop trigger if exists weesh_ratings_sync_driver_summary on public.weesh_ratings;
create trigger weesh_ratings_sync_driver_summary
after insert or update or delete on public.weesh_ratings
for each row execute function private.handle_driver_rating_summary_sync();

drop trigger if exists drivers_touch_last_seen on public.drivers;
create trigger drivers_touch_last_seen
before update on public.drivers
for each row execute function private.touch_driver_last_seen();

drop trigger if exists wallet_accounts_touch_updated_at on public.wallet_accounts;
create trigger wallet_accounts_touch_updated_at
before update on public.wallet_accounts
for each row execute function public.touch_updated_at();

drop trigger if exists weesh_ratings_touch_updated_at on public.weesh_ratings;
create trigger weesh_ratings_touch_updated_at
before update on public.weesh_ratings
for each row execute function public.touch_updated_at();

drop trigger if exists weesh_complaints_touch_updated_at on public.weesh_complaints;
create trigger weesh_complaints_touch_updated_at
before update on public.weesh_complaints
for each row execute function public.touch_updated_at();

alter table public.wallet_accounts enable row level security;
alter table public.weesh_events enable row level security;
alter table public.weesh_ratings enable row level security;
alter table public.weesh_complaints enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'wallet_accounts' and policyname = 'wallet_accounts_select_own'
  ) then
    create policy wallet_accounts_select_own
      on public.wallet_accounts
      for select
      to authenticated
      using (user_id = (select auth.uid()) or (select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_events' and policyname = 'weesh_events_select_member'
  ) then
    create policy weesh_events_select_member
      on public.weesh_events
      for select
      to authenticated
      using ((select private.can_access_weesh(weesh_id)));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_events' and policyname = 'weesh_events_insert_member'
  ) then
    create policy weesh_events_insert_member
      on public.weesh_events
      for insert
      to authenticated
      with check (
        ((actor_user_id is null) or actor_user_id = (select auth.uid()))
        and (select private.can_access_weesh(weesh_id))
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_ratings' and policyname = 'weesh_ratings_select_related'
  ) then
    create policy weesh_ratings_select_related
      on public.weesh_ratings
      for select
      to authenticated
      using (
        rater_user_id = (select auth.uid())
        or rated_user_id = (select auth.uid())
        or (select private.can_access_weesh(weesh_id))
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_ratings' and policyname = 'weesh_ratings_insert_own'
  ) then
    create policy weesh_ratings_insert_own
      on public.weesh_ratings
      for insert
      to authenticated
      with check (
        rater_user_id = (select auth.uid())
        and (select private.can_access_weesh(weesh_id))
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_ratings' and policyname = 'weesh_ratings_update_own'
  ) then
    create policy weesh_ratings_update_own
      on public.weesh_ratings
      for update
      to authenticated
      using (rater_user_id = (select auth.uid()))
      with check (rater_user_id = (select auth.uid()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_complaints' and policyname = 'weesh_complaints_select_related'
  ) then
    create policy weesh_complaints_select_related
      on public.weesh_complaints
      for select
      to authenticated
      using (
        reporter_user_id = (select auth.uid())
        or reported_user_id = (select auth.uid())
        or (select private.is_admin())
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_complaints' and policyname = 'weesh_complaints_insert_own'
  ) then
    create policy weesh_complaints_insert_own
      on public.weesh_complaints
      for insert
      to authenticated
      with check (
        reporter_user_id = (select auth.uid())
        and (weesh_id is null or (select private.can_access_weesh(weesh_id)))
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weesh_complaints' and policyname = 'weesh_complaints_update_owner_or_admin'
  ) then
    create policy weesh_complaints_update_owner_or_admin
      on public.weesh_complaints
      for update
      to authenticated
      using (reporter_user_id = (select auth.uid()) or (select private.is_admin()))
      with check (reporter_user_id = (select auth.uid()) or (select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'users' and policyname = 'users_select_admin'
  ) then
    create policy users_select_admin
      on public.users
      for select
      to authenticated
      using ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'drivers' and policyname = 'drivers_select_admin'
  ) then
    create policy drivers_select_admin
      on public.drivers
      for select
      to authenticated
      using ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'drivers' and policyname = 'drivers_update_admin'
  ) then
    create policy drivers_update_admin
      on public.drivers
      for update
      to authenticated
      using ((select private.is_admin()))
      with check ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weeshes' and policyname = 'weeshes_select_admin'
  ) then
    create policy weeshes_select_admin
      on public.weeshes
      for select
      to authenticated
      using ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'weeshes' and policyname = 'weeshes_update_admin'
  ) then
    create policy weeshes_update_admin
      on public.weeshes
      for update
      to authenticated
      using ((select private.is_admin()))
      with check ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'parcel_details' and policyname = 'parcel_details_select_admin'
  ) then
    create policy parcel_details_select_admin
      on public.parcel_details
      for select
      to authenticated
      using ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'parcel_details' and policyname = 'parcel_details_update_admin'
  ) then
    create policy parcel_details_update_admin
      on public.parcel_details
      for update
      to authenticated
      using ((select private.is_admin()))
      with check ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'grocery_orders' and policyname = 'grocery_orders_select_admin'
  ) then
    create policy grocery_orders_select_admin
      on public.grocery_orders
      for select
      to authenticated
      using ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'grocery_orders' and policyname = 'grocery_orders_update_admin'
  ) then
    create policy grocery_orders_update_admin
      on public.grocery_orders
      for update
      to authenticated
      using ((select private.is_admin()))
      with check ((select private.is_admin()));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'transactions' and policyname = 'transactions_select_admin'
  ) then
    create policy transactions_select_admin
      on public.transactions
      for select
      to authenticated
      using ((select private.is_admin()));
  end if;
end
$$;

create or replace function public.get_wallet_snapshot()
returns table(
  user_id uuid,
  currency text,
  available_balance numeric,
  pending_balance numeric,
  lifetime_credits numeric,
  lifetime_debits numeric,
  last_transaction_at timestamptz
)
language sql
stable
set search_path = public
as $$
  select
    wa.user_id,
    wa.currency,
    wa.available_balance,
    wa.pending_balance,
    wa.lifetime_credits,
    wa.lifetime_debits,
    wa.last_transaction_at
  from public.wallet_accounts wa
  where wa.user_id = (select auth.uid());
$$;

create or replace function public.get_my_activity(p_limit integer default 20)
returns table(
  event_id uuid,
  weesh_id uuid,
  request_code text,
  weesh_type public.weesh_type_enum,
  service_code text,
  status public.weesh_status_enum,
  event_type public.weesh_event_type_enum,
  title text,
  description text,
  created_at timestamptz
)
language sql
stable
set search_path = public
as $$
  select
    e.id as event_id,
    w.id as weesh_id,
    w.request_code,
    w.type as weesh_type,
    w.service_code,
    w.status,
    e.event_type,
    e.title,
    e.description,
    e.created_at
  from public.weesh_events e
  join public.weeshes w on w.id = e.weesh_id
  where (select private.can_access_weesh(w.id))
  order by e.created_at desc
  limit greatest(coalesce(p_limit, 20), 1);
$$;

alter table public.weeshes
  alter column request_code set not null;
