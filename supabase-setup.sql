-- ============================================
-- RentSplit — Esquema de base de datos
-- Pegar TODO en Supabase: SQL Editor → New query → Run
-- ============================================

-- Usuarios de la app (Ricardo y Javier, contraseña 123)
create table rent_users (
  id bigint generated always as identity primary key,
  username text unique not null,
  password text not null,
  created_at timestamptz default now()
);
insert into rent_users (username, password) values ('Ricardo', '123'), ('Javier', '123');

-- Un registro por mes (renta y montos manuales de cada quien)
create table rent_months (
  id bigint generated always as identity primary key,
  period text unique not null,        -- "AAAA-MM" (ej. "2026-07")
  rent_total numeric not null default 0,
  pay_luis numeric not null default 0,
  pay_ricardo numeric not null default 0,
  pay_javier numeric not null default 0,
  note text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Servicios de cada mes (editables: agregar/quitar/cambiar monto)
-- split: '3' = entre los tres | '2' = solo Ricardo y Javier
create table rent_services (
  id bigint generated always as identity primary key,
  period text not null references rent_months(period) on delete cascade,
  name text not null,
  amount numeric not null default 0,
  split text not null default '2',    -- '3' (con Luis) o '2' (sin Luis)
  created_at timestamptz default now()
);

-- RLS
alter table rent_users    enable row level security;
alter table rent_months   enable row level security;
alter table rent_services enable row level security;
create policy "acc rent_users"    on rent_users    for all to anon using (true) with check (true);
create policy "acc rent_months"   on rent_months   for all to anon using (true) with check (true);
create policy "acc rent_services" on rent_services for all to anon using (true) with check (true);
