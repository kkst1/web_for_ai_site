create extension if not exists pgcrypto;

create table if not exists public.ai_sites (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  url text not null,
  sort_order integer not null default 1,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.ai_sites enable row level security;

drop policy if exists "Public can read ai sites" on public.ai_sites;
create policy "Public can read ai sites"
on public.ai_sites
for select
to anon
using (true);

drop policy if exists "Public can insert ai sites" on public.ai_sites;
create policy "Public can insert ai sites"
on public.ai_sites
for insert
to anon
with check (true);

drop policy if exists "Public can update ai sites" on public.ai_sites;
create policy "Public can update ai sites"
on public.ai_sites
for update
to anon
using (true)
with check (true);

drop policy if exists "Public can delete ai sites" on public.ai_sites;
create policy "Public can delete ai sites"
on public.ai_sites
for delete
to anon
using (true);
