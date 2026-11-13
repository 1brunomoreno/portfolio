-- Portfólio brunomorenodev.com.br
-- Rode este script no SQL Editor do Supabase (uma única vez).

-- 1) Quem pode editar o portfólio
create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.admins enable row level security;
create policy "admin vê o próprio registro" on public.admins
  for select to authenticated using (user_id = auth.uid());

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

-- 2) Projetos
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9-]+$'),
  title text not null,
  client text,
  summary text,
  challenge text,
  solution text[] not null default '{}',
  result text,
  tech text[] not null default '{}',
  cover_url text,
  before_url text,
  before_caption text,
  images jsonb not null default '[]'::jsonb,
  sort int not null default 0,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.touch_updated_at() returns trigger
language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists projects_touch on public.projects;
create trigger projects_touch before update on public.projects
  for each row execute function public.touch_updated_at();

alter table public.projects enable row level security;
create policy "público vê projetos publicados" on public.projects
  for select to anon, authenticated using (published or public.is_admin());
create policy "admin cria projetos" on public.projects
  for insert to authenticated with check (public.is_admin());
create policy "admin edita projetos" on public.projects
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin exclui projetos" on public.projects
  for delete to authenticated using (public.is_admin());

-- 3) Imagens (bucket público "portfolio")
insert into storage.buckets (id, name, public)
values ('portfolio', 'portfolio', true)
on conflict (id) do nothing;

create policy "público vê imagens do portfólio" on storage.objects
  for select to anon, authenticated using (bucket_id = 'portfolio');
create policy "admin envia imagens" on storage.objects
  for insert to authenticated with check (bucket_id = 'portfolio' and public.is_admin());
create policy "admin altera imagens" on storage.objects
  for update to authenticated using (bucket_id = 'portfolio' and public.is_admin());
create policy "admin exclui imagens" on storage.objects
  for delete to authenticated using (bucket_id = 'portfolio' and public.is_admin());

-- 4) Depois de criar o seu usuário em Authentication > Users,
--    rode a linha abaixo trocando o e-mail:
-- insert into public.admins (user_id)
--   select id from auth.users where email = 'SEU-EMAIL@exemplo.com';
