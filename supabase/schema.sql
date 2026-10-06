-- Encuesta de bienvenida · Vivo 47 Center
-- Pega este archivo completo en Supabase → SQL Editor → Run.
-- Es seguro correrlo más de una vez.

create schema if not exists extensions;
create extension if not exists pgcrypto with schema extensions;

-- 1. Respuestas de los socios ------------------------------------------------

create table if not exists public.respuestas (
  id         uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  nombre     text   not null check (char_length(nombre) between 1 and 200),
  lada       text   not null default '+52' check (char_length(lada) <= 8),
  telefono   text   not null check (char_length(telefono) between 6 and 30),
  objetivo   text   check (char_length(objetivo) <= 100),
  meta90     text   check (char_length(meta90) <= 1000),
  dias       text   check (char_length(dias) <= 50),
  horario    text   check (char_length(horario) <= 50),
  duracion   text   check (char_length(duracion) <= 50),
  capacidad  text[] not null default '{}' check (cardinality(capacidad) <= 10),
  zonas_gym  text[] not null default '{}' check (cardinality(zonas_gym) <= 20),
  relacion   text   check (char_length(relacion) <= 100),
  condicion  text   check (char_length(condicion) <= 100),
  abandono   text[] not null default '{}' check (cardinality(abandono) <= 10),
  frase      text   check (char_length(frase) <= 500),
  dia_vemos  date
);

alter table public.respuestas enable row level security;

-- Quien llena la encuesta solo puede AGREGAR. No puede leer, editar ni borrar.
revoke all on public.respuestas from anon, authenticated;
grant insert on public.respuestas to anon, authenticated;

drop policy if exists "socios envian respuestas" on public.respuestas;
create policy "socios envian respuestas"
  on public.respuestas for insert to anon, authenticated
  with check (true);

-- 2. Contraseña de administración -------------------------------------------
-- Se guarda cifrada (bcrypt) en una tabla a la que nadie accede desde la web.

create table if not exists public.admin_config (
  id            int primary key default 1 check (id = 1),
  password_hash text not null
);

alter table public.admin_config enable row level security;
revoke all on public.admin_config from anon, authenticated;

-- 3. Funciones del panel Admin ----------------------------------------------
-- Cada una valida la contraseña en el servidor antes de hacer nada.

create or replace function public.admin_check(pw text)
returns boolean
language plpgsql security definer
set search_path = public, extensions
as $$
declare ok boolean;
begin
  select exists (
    select 1 from public.admin_config
    where id = 1 and password_hash = extensions.crypt(coalesce(pw, ''), password_hash)
  ) into ok;
  if not ok then
    perform pg_sleep(1); -- frena intentos de adivinar la contraseña
  end if;
  return ok;
end $$;

create or replace function public.admin_list(pw text)
returns setof public.respuestas
language plpgsql security definer
set search_path = public, extensions
as $$
begin
  if not public.admin_check(pw) then
    raise exception 'PASSWORD_INCORRECTA';
  end if;
  return query select * from public.respuestas order by created_at desc;
end $$;

create or replace function public.admin_delete(pw text, ids uuid[])
returns integer
language plpgsql security definer
set search_path = public, extensions
as $$
declare n integer;
begin
  if not public.admin_check(pw) then
    raise exception 'PASSWORD_INCORRECTA';
  end if;
  delete from public.respuestas where id = any(ids);
  get diagnostics n = row_count;
  return n;
end $$;

create or replace function public.admin_delete_all(pw text)
returns integer
language plpgsql security definer
set search_path = public, extensions
as $$
declare n integer;
begin
  if not public.admin_check(pw) then
    raise exception 'PASSWORD_INCORRECTA';
  end if;
  delete from public.respuestas where true;
  get diagnostics n = row_count;
  return n;
end $$;

revoke all on function public.admin_check(text)            from public;
revoke all on function public.admin_list(text)             from public;
revoke all on function public.admin_delete(text, uuid[])   from public;
revoke all on function public.admin_delete_all(text)       from public;
grant execute on function public.admin_check(text)            to anon, authenticated;
grant execute on function public.admin_list(text)             to anon, authenticated;
grant execute on function public.admin_delete(text, uuid[])   to anon, authenticated;
grant execute on function public.admin_delete_all(text)       to anon, authenticated;
