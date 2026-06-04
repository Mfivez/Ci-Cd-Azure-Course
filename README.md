# Cours progressif — CI/CD, Azure DevOps et déploiements Azure — 4 jours

Ce dossier propose un parcours **progressif et exploitable** pour animer 4 jours de cours autour de la CI, du CD, des environnements et des déploiements Azure avec Azure DevOps.

Le support initial est très large. Ici, le cours est volontairement recentré pour ne pas noyer les participants. Le fil rouge est simple :

```text
Code source
  ↓
Pipeline Azure DevOps
  ↓
CI : build + tests + qualité
  ↓
Artefact versionné
  ↓
CD : Dev → Test/Staging → Production
  ↓
Approvals, secrets, rollback, monitoring
```

## Découpage en 4 jours

| Jour | Thème | Objectif principal |
|---|---|---|
| J1 | Fondations DevOps, Azure DevOps et YAML | Comprendre CI/CD, pipeline, stage, job, step, agent et YAML |
| J2 | CI concrète | Construire un pipeline qui restaure, teste, build et publie un artefact |
| J3 | CD et environnements Azure | Déployer un artefact vers Dev puis Test/Staging avec variables et environnements |
| J4 | Production propre | Protéger la prod avec approvals, secrets, slots, rollback et checklist finale |

## Structure des dossiers

```text
cours_ci_cd_azure_devops_4jours/
├── README.md
├── 00_table_des_matieres.md
├── 00_commun/
├── J1_fondations_et_yaml/
├── J2_ci_build_tests_artefacts/
├── J3_cd_environnements_azure/
└── J4_prod_secrets_slots_rollback/
```

Chaque jour contient :

```text
00_deroule_journee.md       → agenda pédagogique
01_cours.md                 → cours principal prêt à utiliser
02_demo_guidee.md           → déroulé de démonstration
03_ateliers.md              → exercices apprenants
04_corrections.md           → corrigés
05_notes_formateur.md       → conseils d’animation et pièges à éviter
```

## Fil rouge conseillé

Utiliser une application web fictive très simple : **Croissant Web**.

Fonctionnalités minimales :

```text
GET /        → affiche "Hello from <environment>"
GET /health  → retourne "OK"
```

On évite une application complexe. Le sujet du cours est la chaîne CI/CD, pas le développement applicatif.

## Ce qu’il faut éviter en profondeur pendant ces 4 jours

Ces sujets peuvent être mentionnés mais pas détaillés, sauf si le public est déjà avancé :

- Azure Boards en profondeur ;
- Scrum, CMMI, RBAC complet ;
- Terraform Azure DevOps ;
- agent self-hosted Docker complet ;
- Canary avancé ;
- Defender for DevOps détaillé ;
- métriques DORA en profondeur ;
- Kubernetes / AKS.

## Posture formateur

Phrase directrice :

> La CI donne confiance dans le code. Le CD donne confiance dans la livraison.

Répéter souvent :

```text
CI = vérifier
CD = livrer / déployer
Artefact = résultat déployable
Environnement = endroit où l'application tourne
Approval = contrôle humain avant une étape sensible
Rollback = retour arrière prévu avant l'incident
```
