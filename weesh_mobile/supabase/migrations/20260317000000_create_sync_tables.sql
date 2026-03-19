-- Migration: 001_create_sync_tables.sql
-- Create necessary tables for the Weesh Mobile Phase 11 Cloud Sync Engine implementation.

-- 1. weesh_rides
CREATE TABLE public.weesh_rides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    pickup_lat DOUBLE PRECISION NOT NULL,
    pickup_lng DOUBLE PRECISION NOT NULL,
    drop_lat DOUBLE PRECISION NOT NULL,
    drop_lng DOUBLE PRECISION NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.weesh_rides ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can insert their own rides" ON public.weesh_rides FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view their own rides" ON public.weesh_rides FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own rides" ON public.weesh_rides FOR UPDATE USING (auth.uid() = user_id);

-- 2. weesh_parcels
CREATE TABLE public.weesh_parcels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    pickup_lat DOUBLE PRECISION NOT NULL,
    pickup_lng DOUBLE PRECISION NOT NULL,
    drop_lat DOUBLE PRECISION NOT NULL,
    drop_lng DOUBLE PRECISION NOT NULL,
    receiver_name TEXT NOT NULL,
    receiver_phone TEXT NOT NULL,
    parcel_description TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.weesh_parcels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can insert their own parcels" ON public.weesh_parcels FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view their own parcels" ON public.weesh_parcels FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own parcels" ON public.weesh_parcels FOR UPDATE USING (auth.uid() = user_id);

-- 3. weesh_grocery_orders
CREATE TABLE public.weesh_grocery_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    store_name TEXT NOT NULL,
    item_list TEXT NOT NULL,
    drop_lat DOUBLE PRECISION NOT NULL,
    drop_lng DOUBLE PRECISION NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.weesh_grocery_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can insert their own grocery orders" ON public.weesh_grocery_orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view their own grocery orders" ON public.weesh_grocery_orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own grocery orders" ON public.weesh_grocery_orders FOR UPDATE USING (auth.uid() = user_id);
