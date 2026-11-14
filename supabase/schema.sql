-- Table des candidatures Renatus.
-- À coller dans Supabase : SQL Editor > New query > Run.

create table if not exists public.candidatures (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  pseudo      text not null check (char_length(pseudo) between 1 and 24),
  classe      text check (char_length(classe) <= 30),
  role        text not null check (role in ('tank', 'heal', 'dps')),
  verdict     text not null check (char_length(verdict) <= 20),
  rang        text check (char_length(rang) <= 60),
  titre       text check (char_length(titre) <= 40),
  score       numeric,
  tentative   int,          -- n° de tentative dans ce navigateur
  stats       jsonb,        -- notes brutes et sur 10
  test_pull   jsonb,        -- résultat du test de réflexes
  epreuves    jsonb,        -- épreuves de rôle passées
  reponses    jsonb         -- réponses au quiz
);

create index if not exists candidatures_created_at_idx on public.candidatures (created_at desc);
create index if not exists candidatures_pseudo_idx on public.candidatures (lower(pseudo));

-- Sécurité : le site (clé publique) peut seulement AJOUTER un dossier.
-- Personne ne peut lire, modifier ou supprimer via la clé publique :
-- les officiers consultent les dossiers depuis le tableau de bord Supabase.
alter table public.candidatures enable row level security;

drop policy if exists "Les candidats déposent un dossier" on public.candidatures;
create policy "Les candidats déposent un dossier"
  on public.candidatures for insert
  to anon
  with check (true);

grant insert on public.candidatures to anon;
