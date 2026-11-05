-- Run this once in Supabase: SQL Editor → New query → paste → Run.
-- Replace YOUR_EMAIL below with the email address you'll sign in with (two places).

create table if not exists public.deals (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  deleted boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.settings (
  id text primary key,
  data jsonb not null default '{}'::jsonb
);

alter table public.deals enable row level security;
alter table public.settings enable row level security;

-- Only you can read or write. Everyone else, including anyone holding the public key, gets nothing.
drop policy if exists "owner only" on public.deals;
create policy "owner only" on public.deals
  for all to authenticated
  using ((auth.jwt() ->> 'email') = 'YOUR_EMAIL')
  with check ((auth.jwt() ->> 'email') = 'YOUR_EMAIL');

drop policy if exists "owner only" on public.settings;
create policy "owner only" on public.settings
  for all to authenticated
  using ((auth.jwt() ->> 'email') = 'YOUR_EMAIL')
  with check ((auth.jwt() ->> 'email') = 'YOUR_EMAIL');
