# NoSQL Tutorials — Redis, MongoDB & OrientDB

Travaux pratiques de NoSQL réalisés dans le cadre de mon cursus à l'Université Lyon 2.  
Les notebooks couvrent trois bases de données NoSQL : **Redis**, **MongoDB** et **OrientDB**, avec des interactions en Python via Jupyter.

## Stack technique

| Composant | Rôle |
|-----------|------|
| `Redis` | Base clé-valeur |
| `MongoDB 4` | Base documentaire |
| `OrientDB 2.2` | Base orientée graphe |
| `Jupyter Notebook` | Interface Python interactive |
| `Docker / Docker Compose` | Orchestration de l'ensemble |

## Lancement

Cloner le repo puis lancer l'environnement complet avec une seule commande :

```bash
docker compose up --build
```

Jupyter sera accessible sur [http://localhost:8888](http://localhost:8888) (sans mot de passe).

Les notebooks se trouvent dans le dossier `notebooks/`, les données dans `data/`.

## Docker

### `Dockerfile`

Le Dockerfile construit l'image du service Jupyter. Il part de l'image officielle `jupyter/minimal-notebook:python-3.10` et y ajoute :

- **`mongodb-database-tools`** (installé en root via `apt`) — fournit notamment `mongoimport`, utilisé dans le notebook MongoDB pour charger les datasets MovieLens
- **`redis`, `pymongo`, `pyorient`** (installés via `pip`) — les drivers Python pour interagir avec chacune des trois bases

### `docker-compose.yaml`

Le fichier orchestre quatre services qui communiquent sur un réseau Docker interne :

- **`redis`** — image officielle Redis, accessible depuis Jupyter via le hostname `redis`
- **`mongodb`** — image officielle `mongo:4`, accessible via le hostname `mongodb`
- **`orientdb`** — image officielle `orientdb:2.2`, avec le mot de passe root défini via la variable d'environnement `ORIENTDB_ROOT_PASSWORD`
- **`jupyter`** — le service construit depuis le Dockerfile, avec deux volumes montés (`./notebooks` et `./data`), les ports `8888` et `4040` exposés, et une dépendance explicite sur les trois services de base de données

Les ports des bases de données ne sont intentionnellement **pas exposés** sur la machine hôte : les notebooks se connectent directement aux services par leur nom de service Docker (`redis`, `mongodb`, `orientdb`).

## Contenu des notebooks

### `1-redis.ipynb` — Redis

- Manipulation de **strings**, listes, sets, sorted sets et dictionnaires
- Cas pratique : **modélisation d'un cache de requêtes HTTP** (stockage, vérification, suppression de requêtes GET/PUT)

### `2-mongo.ipynb` — MongoDB

- Import de données MovieLens (`users` et `movies`) via `mongoimport`
- Requêtes de filtrage, projection, tri et pagination
- Recherche textuelle avec index `$text`
- Requêtes sur tableaux imbriqués avec `$elemMatch`
- Mise à jour de documents (`update_one`, `update_many`)
- Cas pratique : **modélisation d'un blog** (posts, tags, commentaires imbriqués)

### `3-orientdb.ipynb` — OrientDB

- Création de vertex et d'edges dans une base graphe
- Modélisation de relations entre divinités grecques (fratrie, parenté)
- Navigation dans le graphe avec `out()`, `in()`, `EXPAND()`
- Cas pratique : **système de recommandation produits** — *"Quels produits ont été achetés par des personnes ayant acheté X ?"*

## Structure du projet

```
.
├── docker-compose.yaml
├── Dockerfile
├───lecture
│       nosql_lecture.pdf
├── notebooks/
│   ├── 1-redis.ipynb
│   ├── 2-mongo.ipynb
│   └── 3-orientdb.ipynb
└── data/
    ├── movielens_movies.json
    └── movielens_users.json
```

## Crédits

Exercices originaux (sans les réponses) fournis par mon enseignant.
Dockerisation et adaptation personnelle ajoutées par moi.
