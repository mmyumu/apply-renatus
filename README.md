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

Le site est une image nginx (`Dockerfile`, `deploy/nginx.conf`), en ligne sur
https://renatus.mmyumu.fr, déployé sur le VPS comme les autres projets :

- recette Normandy `/etc/normandy-deploy/apply-renatus.json` (VPS et pi5) : l'image
  `registry.mmyumu.fr/apply-renatus:<sha git>` est construite sur le VPS depuis GitHub ;
- stack Compose `/home/mmyumu/docker/apply-renatus/compose.yml` sur le VPS (conteneur en lecture
  seule, sur le réseau `internal`, sans port publié), version active dans `.env.normandy` ;
- le nginx partagé (`infra/nginx/conf.d/renatus.conf`) fait le HTTPS et transmet au conteneur.

Mettre à jour : pousser sur `main` ; Normandy voit que GitHub est en avance sur ce qui tourne et
lance le déploiement (`normandy-release build` puis `activate`, retour arrière automatique si le
conteneur ne reste pas sain).

Le `compose.yml` du dépôt sert seulement à lancer le site en local :

```sh
docker compose up --build    # puis http://127.0.0.1:8095
```
