-- Métricas anônimas do site (rode depois do schema.sql)
create table if not exists public.events (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  type text not null check (type in ('page_view','whatsapp_click','project_open','filter')),
  slug text check (char_length(slug) <= 80),
  source text check (char_length(source) <= 40),
  device text check (device in ('celular','computador'))
);
create index if not exists events_created_at_idx on public.events (created_at desc);

alter table public.events enable row level security;

-- Qualquer visitante pode registrar um evento, mas ninguém de fora consegue ler
create policy "visitante registra evento" on public.events
  for insert to anon, authenticated with check (true);
create policy "admin lê eventos" on public.events
  for select to authenticated using (public.is_admin());
create policy "admin apaga eventos" on public.events
  for delete to authenticated using (public.is_admin());
