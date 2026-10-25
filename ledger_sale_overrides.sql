-- Ledger-side record for sales that come from contracts.
-- The contracts table is never touched; this table only stores what the
-- ledger hides (excluded) or adjusts (customer / invoice # / amount / notes).
create table if not exists public.ledger_sale_overrides (
  contract_id    text primary key,          -- the contract's id, stored as text
  excluded       boolean not null default false,
  customer       text,
  invoice_number text,
  sale_amount    numeric(14,2),
  notes          text,
  updated_at     timestamptz not null default now()
);

-- The ledger talks to Supabase with the anon key, so it needs access.
-- IMPORTANT: match whatever your other ledger tables (expenses, payroll_entries,
-- owner_loans) use. If those have RLS off, you can drop the next 3 statements.
alter table public.ledger_sale_overrides enable row level security;
drop policy if exists "ledger_sale_overrides_all" on public.ledger_sale_overrides;
create policy "ledger_sale_overrides_all" on public.ledger_sale_overrides
  for all using (true) with check (true);
