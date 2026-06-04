# J2 — Notes formateur

## Intention pédagogique

Le jour 2 doit rendre la CI concrète. À la fin, les participants doivent comprendre la valeur d’un artefact.

## À marteler

> On ne déploie pas du code source au hasard. On déploie un artefact validé.

> Le pipeline doit être capable de repartir d’une machine propre.

> Un pipeline rouge est un mécanisme de protection.

## Pièges fréquents

### Trop parler d’outils de qualité

SonarQube, OWASP, Defender sont intéressants, mais ils peuvent noyer les débutants.

Rester au niveau :

```text
tests + qualité + sécurité peuvent être automatisés dans la CI
```

### Confondre Azure Artifacts et Pipeline Artifacts

Simplification pour débutants :

- Pipeline Artifact : résultat attaché à un run de pipeline ;
- Azure Artifacts : registre de packages NuGet/npm/Maven.

Au jour 2, Pipeline Artifact suffit.

### Avoir un pipeline qui ne tourne pas

Prévoir un mode simulation :

```text
Même si Azure DevOps n'est pas disponible, on peut lire le YAML et expliquer le run attendu.
```

## Transition vers le jour 3

Phrase de clôture :

> Nous savons maintenant produire un artefact validé. Demain, on va prendre cet artefact et le faire passer dans des environnements : Dev puis Staging.
