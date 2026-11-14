# apply-renatus

Site de candidature (humoristique) pour la guilde **Renatus** : quiz, dilemmes, test du pull,
épreuves Tank / Heal / DPS et verdict du Conseil des Officiers.

Tout tient dans `index.html` : aucune dépendance, aucun build. Le nom de la guilde et les réglages
sont dans le bloc `CONFIG` en haut du script.

## Enregistrer les candidatures (Supabase)

1. Crée un projet gratuit sur https://supabase.com.
2. **SQL Editor > New query**, colle le contenu de `supabase/schema.sql`, puis **Run**.
3. **Project Settings > API** : copie l'URL du projet et la clé publique (`anon` ou `publishable`).
4. Mets-les dans `CONFIG.supabaseUrl` et `CONFIG.supabaseAnonKey` dans `index.html`.

Cette clé est faite pour être publique : avec la sécurité définie dans `schema.sql`, elle permet
seulement d'ajouter un dossier, pas de lire ceux des autres.

Pour consulter les dossiers : **Table Editor > candidatures** dans Supabase. Exemple de requête
(SQL Editor) pour voir qui a tenté sa chance plusieurs fois :

```sql
select pseudo, count(*) as essais, max(score) as meilleur_score, max(created_at) as dernier
from candidatures
group by pseudo
order by dernier desc;
```

Sans configuration Supabase, le site marche quand même : le candidat copie son résumé à la main.

## Déploiement

Le site est une image nginx (`Dockerfile`, `deploy/nginx.conf`) lancée par `compose.yml`, sur le
modèle des autres projets : le port n'écoute que sur `127.0.0.1` (8095 par défaut, réglable avec
`APPLY_RENATUS_PORT`), et le nginx de la machine fait le HTTPS devant.

Avec Normandy : page du projet **apply-renatus**, choisir la machine et le nom (`*.mmyumu.fr`),
puis **Deploy with Claude**.

En local :

```sh
docker compose up --build    # puis http://127.0.0.1:8095
```
