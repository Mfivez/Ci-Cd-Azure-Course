# Fil rouge de démonstration — Croissant Web

## Objectif

Utiliser une application fictive très simple pour illustrer les pipelines, sans perdre de temps sur le code applicatif.

Nom : **Croissant Web**

Type : application web minimale.

Routes :

```text
GET /        → Hello from <ENVIRONMENT_NAME>
GET /health  → OK
```

## Pourquoi cette application ?

Elle permet de montrer :

- la différence entre Dev, Staging et Prod ;
- l’usage des variables d’environnement ;
- le déploiement d’un même artefact dans plusieurs environnements ;
- les smoke tests ;
- le rollback.

## Structure minimale possible

```text
croissant-web/
├── package.json
├── src/
│   └── server.js
├── tests/
│   └── health.test.js
└── azure-pipelines.yml
```

## Exemple de code Node.js minimal

```js
const express = require('express');
const app = express();

const envName = process.env.ENVIRONMENT_NAME || 'local';

app.get('/', (req, res) => {
  res.send(`Hello from ${envName}`);
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Croissant Web running on port ${port}`);
});
```

## Exemple package.json

```json
{
  "name": "croissant-web",
  "version": "1.0.0",
  "scripts": {
    "start": "node src/server.js",
    "test": "node tests/health.test.js",
    "build": "echo build-ok"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

## Test minimal volontairement simple

```js
console.log('health test ok');
process.exit(0);
```

## Remarque formateur

L’application n’est pas le sujet. Elle sert uniquement de support pour voir les pipelines.

Ne pas passer plus de 20 minutes sur le code applicatif.
