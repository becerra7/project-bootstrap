-- ─────────────────────────────────────────────────────────────────────────
-- Migration NNN — {{description}}
-- User-owned table template. Copy, rename, fill in columns.
-- ─────────────────────────────────────────────────────────────────────────

create table if not exists public.{{table}} (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references auth.users(id) on delete cascade,
    -- domain columns (snake_case, mirror the DTO exactly):
    -- name      text not null,
    -- amount    numeric,
    -- payload   jsonb not null default '{}'::jsonb,
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now()
);

-- Keep updated_at fresh on every change.
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists {{table}}_updated_at on public.{{table}};
create trigger {{table}}_updated_at
    before update on public.{{table}}
    for each row execute procedure public.set_updated_at();

-- RLS: default deny, owner-only access.
alter table public.{{table}} enable row level security;

create policy "user crud own {{table}}"
    on public.{{table}}
    for all
    using      (auth.uid() = user_id)
    with check (auth.uid() = user_id);

-- Helpful index for the common "my rows" query.
create index if not exists {{table}}_user_id_idx on public.{{table}} (user_id);
