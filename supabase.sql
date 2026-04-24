create extension if not exists pgcrypto;

create table if not exists public.ai_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sort_order integer not null default 1,
  created_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists ai_categories_name_key
on public.ai_categories (name);

insert into public.ai_categories (name, sort_order)
values
  ('GPT', 1),
  ('Gemini', 2),
  ('其他', 3)
on conflict (name) do nothing;

create table if not exists public.ai_sites (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  url text not null,
  category text not null default '其他',
  tags text[] not null default array['其他'],
  url_normalized text,
  domain_normalized text,
  sort_order integer not null default 1,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.ai_sites
add column if not exists category text not null default '其他';

alter table public.ai_sites
add column if not exists tags text[] not null default array['其他'];

update public.ai_sites
set category = '其他'
where category is null or btrim(category) = '';

update public.ai_sites
set tags = array[category]
where tags is null or array_length(tags, 1) is null;

insert into public.ai_categories (name, sort_order)
select distinct category, 1000 + row_number() over (order by category)
from public.ai_sites
where category is not null and btrim(category) <> ''
on conflict (name) do nothing;

alter table public.ai_sites
add column if not exists url_normalized text;

alter table public.ai_sites
add column if not exists domain_normalized text;

update public.ai_sites
set url_normalized = lower(regexp_replace(url, '/+$', ''))
where url_normalized is null;

update public.ai_sites
set domain_normalized = lower(regexp_replace(regexp_replace(url, '^https?://', ''), '^www\.', ''))
where domain_normalized is null;

update public.ai_sites
set domain_normalized = split_part(domain_normalized, '/', 1)
where position('/' in domain_normalized) > 0;

alter table public.ai_sites
alter column url_normalized set not null;

alter table public.ai_sites
alter column domain_normalized set not null;

drop index if exists ai_sites_url_normalized_key;

create unique index if not exists ai_sites_domain_normalized_key
on public.ai_sites (domain_normalized);

alter table public.ai_categories enable row level security;
alter table public.ai_sites enable row level security;

drop policy if exists "Public can read ai categories" on public.ai_categories;
create policy "Public can read ai categories"
on public.ai_categories
for select
to anon
using (true);

drop policy if exists "Public can insert ai categories" on public.ai_categories;
create policy "Public can insert ai categories"
on public.ai_categories
for insert
to anon
with check (true);

drop policy if exists "Public can update ai categories" on public.ai_categories;
create policy "Public can update ai categories"
on public.ai_categories
for update
to anon
using (true)
with check (true);

drop policy if exists "Public can delete ai categories" on public.ai_categories;
create policy "Public can delete ai categories"
on public.ai_categories
for delete
to anon
using (true);

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
