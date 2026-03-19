create index if not exists weesh_complaints_weesh_id_idx
  on public.weesh_complaints(weesh_id);

create index if not exists weesh_complaints_reported_user_id_idx
  on public.weesh_complaints(reported_user_id);

create index if not exists weesh_ratings_rater_user_idx
  on public.weesh_ratings(rater_user_id, created_at desc);

create index if not exists weeshes_cancelled_by_idx
  on public.weeshes(cancelled_by);

drop policy if exists drivers_select_own on public.drivers;
drop policy if exists drivers_select_admin on public.drivers;
create policy drivers_select_self_or_admin
  on public.drivers
  for select
  to authenticated
  using (id = (select auth.uid()) or (select private.is_admin()));

drop policy if exists drivers_update_own on public.drivers;
drop policy if exists drivers_update_admin on public.drivers;
create policy drivers_update_self_or_admin
  on public.drivers
  for update
  to authenticated
  using (id = (select auth.uid()) or (select private.is_admin()))
  with check (id = (select auth.uid()) or (select private.is_admin()));

drop policy if exists users_select_own on public.users;
drop policy if exists users_select_admin on public.users;
create policy users_select_self_or_admin
  on public.users
  for select
  to authenticated
  using (id = (select auth.uid()) or (select private.is_admin()));

drop policy if exists weeshes_select_member on public.weeshes;
drop policy if exists weeshes_select_admin on public.weeshes;
create policy weeshes_select_member_or_admin
  on public.weeshes
  for select
  to authenticated
  using (
    user_id = (select auth.uid())
    or driver_id = (select auth.uid())
    or (select private.is_admin())
  );

drop policy if exists weeshes_update_member on public.weeshes;
drop policy if exists weeshes_update_admin on public.weeshes;
create policy weeshes_update_member_or_admin
  on public.weeshes
  for update
  to authenticated
  using (
    user_id = (select auth.uid())
    or driver_id = (select auth.uid())
    or (select private.is_admin())
  )
  with check (
    user_id = (select auth.uid())
    or driver_id = (select auth.uid())
    or (select private.is_admin())
  );

drop policy if exists parcel_details_select_member on public.parcel_details;
drop policy if exists parcel_details_select_admin on public.parcel_details;
create policy parcel_details_select_member_or_admin
  on public.parcel_details
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.weeshes w
      where w.id = parcel_details.weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
          or (select private.is_admin())
        )
    )
  );

drop policy if exists parcel_details_update_member on public.parcel_details;
drop policy if exists parcel_details_update_admin on public.parcel_details;
create policy parcel_details_update_member_or_admin
  on public.parcel_details
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.weeshes w
      where w.id = parcel_details.weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
          or (select private.is_admin())
        )
    )
  )
  with check (
    exists (
      select 1
      from public.weeshes w
      where w.id = parcel_details.weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
          or (select private.is_admin())
        )
    )
  );

drop policy if exists grocery_orders_select_member on public.grocery_orders;
drop policy if exists grocery_orders_select_admin on public.grocery_orders;
create policy grocery_orders_select_member_or_admin
  on public.grocery_orders
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.weeshes w
      where w.id = grocery_orders.weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
          or (select private.is_admin())
        )
    )
  );

drop policy if exists grocery_orders_update_member on public.grocery_orders;
drop policy if exists grocery_orders_update_admin on public.grocery_orders;
create policy grocery_orders_update_member_or_admin
  on public.grocery_orders
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.weeshes w
      where w.id = grocery_orders.weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
          or (select private.is_admin())
        )
    )
  )
  with check (
    exists (
      select 1
      from public.weeshes w
      where w.id = grocery_orders.weesh_id
        and (
          w.user_id = (select auth.uid())
          or w.driver_id = (select auth.uid())
          or (select private.is_admin())
        )
    )
  );

drop policy if exists transactions_select_owner on public.transactions;
drop policy if exists transactions_select_admin on public.transactions;
create policy transactions_select_owner_or_admin
  on public.transactions
  for select
  to authenticated
  using (user_id = (select auth.uid()) or (select private.is_admin()));
