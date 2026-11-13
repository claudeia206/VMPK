# Feuille de route VMPK

> Plan de développement du dépôt [claudeia206/VMPK](https://github.com/claudeia206/VMPK), miroir de [pedrolcl/VMPK](https://github.com/pedrolcl/VMPK). Cette feuille de route est pilotée par les risques : fiabilité de compilation d'abord, documentation et tests ensuite, fonctionnalités enfin.

## Vision et objectifs

- Maintenir un VMPK fiable sur Linux, Windows et macOS.
- Préserver le comportement MIDI, les mappings clavier et la compatibilité avec l'amont.
- Rendre les builds et les paquets reproductibles, sans dépendance à des artefacts non maîtrisés.
- Faire évoluer le projet par changements petits, testables et réversibles.
- Conserver les licences, crédits, traductions et conventions du projet upstream.

## Règles de pilotage

1. Suivre les phases dans l'ordre ci-dessous ; ne pas démarrer une fonctionnalité P2 tant qu'un blocage P0/P1 empêche de construire ou tester correctement.
2. Une tâche n'est cochée qu'après preuve vérifiable (CI verte, test reproductible, documentation relue ou PR fusionnée).
3. Travailler dans une branche dédiée et une PR ciblée ; ne pas pousser directement sur `master` ou `devel`.
4. Ne jamais fusionner une PR si un job requis est en attente, en cours, échoué ou annulé.
5. Pour la PR #1, exiger explicitement Linux x86_64 (runner Linux Mint self-hosted) **et** Linux ARM64 verts avant toute fusion. Les autres plateformes doivent aussi être examinées.
6. Ne pas contourner un échec en masquant le test, en neutralisant une étape ou en élargissant les permissions sans justification.
7. Préférer les versions stables et épinglées des dépendances ; documenter les contournements temporaires et leur condition de retrait.
8. À chaque étape : lire le code et les issues existantes, vérifier l'amont, limiter le diff, lancer les contrôles pertinents, relire le résultat et mettre à jour cette roadmap.
9. Les notifications de workflows par e-mail restent désactivées ; utiliser les rapports ChatGPT pour le suivi.
10. En cas de blocage nécessitant une action locale (runner hors ligne, matériel MIDI absent, permission manquante), fournir la commande ou l'action exacte et poursuivre les tâches indépendantes.

## Tableau de bord

| Domaine | Priorité | État | Condition de sortie |
|---|---:|---|---|
| PR #1 et CI de référence | P0 | Terminée (07/11/2026) | PR #1 fusionnée ; CI verte sur Linux x86_64/ARM64, Windows MSVC/MSYS2 et macOS |
| Cohérence CI et dépendances | P0 | En cours — validation AppDir, pin x86_64 et permissions minimales incomplets | PR #3 valide le pin Drumstick sur ARM64 seulement ; PR #6 teste le runtime AppDir ; PR #7 réduit les permissions Linux ; runner x86_64 non attribué |
| Documentation d'installation et dépannage | P1 | En cours | Matrice CI documentée dans [PR #4](https://github.com/claudeia206/VMPK/pull/4) ; guide installation/MIDI encore à faire |
| Tests de non-régression | P1 | À faire | Tests automatisés utiles + scénarios manuels documentés |
| Bugs et fonctionnalités demandées | P2 | À planifier | Priorité confirmée par issues et faisabilité |
| UX, clavier et traductions | P2/P3 | À planifier | Changements vérifiés sans régression MIDI |
| Releases et maintenance | P3 | À planifier | Checklist et procédure de publication reproductibles |

## Phase 0 — Stabilisation et état des lieux (P0)

- [x] Établir une roadmap en phases avec critères de sortie.
- [x] Finaliser la [PR #1](https://github.com/claudeia206/VMPK/pull/1) : fusion squash le 07/11/2026, commit [295fd10](https://github.com/claudeia206/VMPK/commit/295fd10b688d36b0b06fc6aba6cb56d0e32c68a2).
- [x] Linux x86_64 : **success** sur runner self-hosted Linux Mint `linux-UX303LA` ([run PR #1](https://github.com/claudeia206/VMPK/actions/runs/42338619625), job 128301115613).
- [x] Linux ARM64 : **success** sur runner GitHub `ubuntu-24.04-arm` ([run PR #1](https://github.com/claudeia206/VMPK/actions/runs/42338619625), job 128301115414).
- [x] Windows MSVC ([run](https://github.com/claudeia206/VMPK/actions/runs/42338619573)), Windows MSYS2 ([run](https://github.com/claudeia206/VMPK/actions/runs/42338619619)) et macOS ([run](https://github.com/claudeia206/VMPK/actions/runs/42338619626)) : tous les jobs requis terminés en **success** sur le head `b70b9ab`.
- [x] Examiner les logs de la PR #1 : aucun échec dans les runs finaux retenus. Les échecs historiques de PR #2 sur le head précédent `e4ce314` provenaient de l'étape `Download Drumstick` : `Input required and not supplied: github_token`.
- [x] Inspecter structurellement les artefacts de PR #1 : AppDir/AppImage Linux, installeurs MSVC x64/ARM64 et ZIP macOS x86_64/ARM64. L'installation/lancement réel reste une tâche Phase 1.
- [x] Relire le diff de la PR #1 : changements CI ciblés, sans changement fonctionnel VMPK.

### Suivi CI des PR ouvertes (10/11/2026)

- [PR #2](https://github.com/claudeia206/VMPK/pull/2), head `d46160390f7ee4b4ff2abbbef26b4dbb21281f90` : Linux ARM64, Windows MSVC x64/ARM64, MSYS2 ucrt64/clang64/clangarm64 et macOS x86_64/ARM64 **success**. Linux x86_64 **cancelled** après 24 h d'attente ; job `128671328713`, label `self-hosted`, `runner_id=0`, aucun runner nommé ni aucune étape ([run](https://github.com/claudeia206/VMPK/actions/runs/42461423279)).
- [PR #3](https://github.com/claudeia206/VMPK/pull/3), head `6d6472b1acfb68c68de068489e1ddb3dd6536d39` : Linux ARM64, Windows MSVC x64/ARM64, MSYS2 et macOS x86_64/ARM64 **success**. Linux x86_64 **cancelled** après 24 h d'attente sans runner attribué ; job `128671944410`, label `self-hosted`, `runner_id=0`, aucune étape ([run](https://github.com/claudeia206/VMPK/actions/runs/42461626903)).
- [PR #4](https://github.com/claudeia206/VMPK/pull/4), head `65c5fb8b0d72421a7de90dacb3b42aa8447da648` : Linux ARM64 **success** avec AppDir/AppImage ; Windows MSVC, Windows MSYS2 et macOS **success** avec artefacts MSVC x64/ARM64 et ZIP macOS x86_64/ARM64. Linux x86_64 **failure** ([run](https://github.com/claudeia206/VMPK/actions/runs/42588964777), job `129065572750`). Les étapes indiquent que le job s'est arrêté pendant `VCPKG Build`, mais l'étape apparaît encore `in_progress` et le téléchargement des logs renvoie `404 BlobNotFound` ; **la cause n'est pas démontrée**. Aucun artefact x86_64.
- [PR #5](https://github.com/claudeia206/VMPK/pull/5), head `b8b77500ba7e69ffe8659f9c2f930600b0f7fc49` : Linux ARM64 **success** avec AppDir/AppImage ; Windows MSVC, Windows MSYS2 et macOS **success** avec leurs artefacts. Linux x86_64 reste **queued** ([run](https://github.com/claudeia206/VMPK/actions/runs/42589015261), job `129065748333`) ; aucun runner n'est indiqué dans le résultat du job, aucune étape n'a commencé. Le workflow `pull_request_target` retourne success, mais GitHub exécute la version de base du workflow : cela ne valide pas le fichier modifié dans cette PR.
- Ces annulations ne sont pas des échecs de compilation ni des succès. Aucun log de build n'existe pour les jobs x86_64 annulés. Le runner self-hosted n'a pas été attribué par GitHub ; état systemd local à vérifier manuellement.

**Action locale requise si le runner reste indisponible :**

```bash
sudo systemctl status actions.runner.claudeia206-VMPK.linux-UX303LA.service --no-pager
sudo journalctl -u actions.runner.claudeia206-VMPK.linux-UX303LA.service -n 80 --no-pager
```

## Phase 1 — CI, compilation et packaging (P0)

- [x] Auditer les déclencheurs : workflows Linux/Windows/macOS sur push et PR vers `devel`/`master`, plus `workflow_dispatch` ; aucun déclencheur de tag n'est présent. Le workflow `pull_request_target` vérifie seulement les branches, sans checkout ni commande provenant de la PR.
- [ ] Valider les permissions minimales explicites : PR #5 propose `permissions: {}` pour `pull_request_target` ; PR #7 propose `contents: read` pour Linux. Windows/MSYS2/macOS restent à auditer en raison du téléchargement d'artefacts upstream ; CI de PR #7 en attente.
- [x] Relever les versions et les écarts entre plateformes ; la matrice est documentée dans [docs/CI-BUILD-MATRIX.md](docs/CI-BUILD-MATRIX.md) (PR #4). Qt 5 est disponible via `USE_QT5` dans CMake mais non testé par les workflows CI actuels.
- [ ] Vérifier la construction de Drumstick depuis une source/version déterministe sur Linux. Le commit upstream fixe `23da19d05ad511bd9140a2d00eedead2ae5bac1a` est compilé avec succès sur ARM64 dans PR #3 ; validation x86_64 toujours bloquée (runner non attribué).
- [x] Vérifier les sources d'artefacts Drumstick Windows/macOS et le fallback `${{ secrets.GH_PAT || github.token }}` ; les builds PR #1 sont verts. La sélection upstream `devel` reste mobile et donc non reproductible au niveau du run.
- [ ] Vérifier les chemins d'installation, bibliothèques partagées, plugins Qt et dépendances MIDI au runtime. PR #6 a révélé `libQt6Network.so.6 => not found` sur ARM64 ; la copie de la chaîne de liens Qt est proposée dans le head `afe9959`, CI en attente.
- [ ] Tester l'installation/lancement des paquets produits, pas seulement leur génération.
- [ ] Réduire les duplications YAML et ajouter des timeouts/cache seulement si cela améliore fiabilité ou durée sans masquer les erreurs.
- [x] Documenter le pin temporaire Qt Linux 6.11.1, la cause et les conditions de réévaluation dans [la matrice CI](docs/CI-BUILD-MATRIX.md) ; état de référence 09/11/2026.

**Critères de sortie :** builds reproductibles et artefacts vérifiés sur les plateformes annoncées ; aucun secret requis inutilement ; permissions minimales.

## Phase 2 — Documentation et installation (P1)

- [ ] Aligner README, CMake, workflows et dépendances sur les versions effectivement supportées. La matrice de versions CI et ses limites est documentée dans [docs/CI-BUILD-MATRIX.md](docs/CI-BUILD-MATRIX.md) (PR #4).
- [ ] Documenter les prérequis et commandes de build Qt 6 ; préciser le statut de Qt 5 et de `USE_QT5`.
- [ ] Écrire des procédures distinctes Linux, Windows et macOS, avec versions testées.
- [ ] Documenter la configuration MIDI : ALSA, ports virtuels, périphériques, permissions, backend et MIDI thru.
- [ ] Ajouter un guide de dépannage : périphérique absent, droits d'accès, bibliothèques partagées, plugins Qt, problèmes audio/MIDI.
- [ ] Décrire la compilation depuis un clone propre et les commandes de vérification.
- [ ] Vérifier les liens, captures et instructions du README depuis un environnement vierge.

**Critères de sortie :** un contributeur peut installer les prérequis, compiler, lancer et diagnostiquer VMPK sans information implicite.

## Phase 3 — Tests et qualité (P1)

- [ ] Inventorier les tests, composants testables et zones sans couverture.
- [ ] Définir une matrice de tests Linux/Windows/macOS et Qt supportés.
- [ ] Ajouter des tests unitaires aux fonctions isolables : mapping clavier, transposition, paramètres et conversions.
- [ ] Tester la persistance des préférences, mappings et connexions MIDI.
- [ ] Couvrir MIDI thru, contrôleurs et changements de périphérique lorsque l'architecture le permet.
- [ ] Documenter les tests manuels nécessitant un clavier/périphérique MIDI physique ou un port virtuel.
- [ ] Activer des contrôles statiques/formatage uniquement s'ils sont compatibles avec le style existant et ne génèrent pas de bruit.
- [ ] Corriger les warnings pertinents par petites PR, sans changement fonctionnel involontaire.

**Critères de sortie :** les régressions courantes sont détectées automatiquement et les tests matériels sont reproductibles avec une procédure claire.

## Phase 4 — Bugs et fonctionnalités (P2)

Aucune fonctionnalité ne démarre avant vérification des issues, discussions et TODO upstream. Prioriser selon l'impact utilisateur, la demande réelle, le coût et les risques MIDI.

Ordre de présélection (à confirmer après audit des issues) :

1. [ ] Corriger les bugs confirmés et faciles à reproduire.
2. [ ] Support cohérent des majuscules/minuscules dans les mappings clavier.
3. [ ] Séparation des canaux MIDI.
4. [ ] Séparation des points de note.
5. [ ] Génération d'accords.
6. [ ] Arpeggiator.
7. [ ] Lecture de fichiers MIDI.
8. [ ] Support des accordéons chromatiques à cinq rangées.

Pour chaque élément :
- retrouver l'issue ou confirmer qu'il s'agit toujours d'un besoin ;
- définir le comportement attendu et les cas limites ;
- vérifier l'architecture existante et les solutions upstream ;
- proposer une PR indépendante ;
- ajouter tests automatisés et/ou scénario manuel ;
- mettre à jour l'aide et les traductions concernées.

## Phase 5 — UX, clavier et traductions (P2/P3)

- [ ] Vérifier focus, navigation clavier, raccourcis et accessibilité.
- [ ] Tester AZERTY, QWERTY et autres dispositions internationales.
- [ ] Améliorer la lisibilité des touches et des états MIDI sans dégrader les performances.
- [ ] Vérifier les interactions souris/tactile et les états visuels.
- [ ] Maintenir les traductions Qt Linguist et éviter les chaînes codées en dur.
- [ ] Préserver les préférences et raccourcis existants lors des évolutions UI.

**Critères de sortie :** UX cohérente sur les plateformes, mappings fiables et traductions à jour.

## Phase 6 — Maintenance et releases (P3)

- [ ] Définir la stratégie de synchronisation avec upstream et la gestion des divergences.
- [ ] Documenter les changements propres au miroir et leurs raisons.
- [ ] Définir les versions supportées et la politique de mise à jour des dépendances.
- [ ] Préparer une checklist de release : tests, notes, licences, artefacts, sommes de contrôle et installation.
- [ ] Tester la procédure de publication sur une préversion avant release stable.
- [ ] Prévoir un plan de retour arrière et l'archivage des artefacts.

**Critères de sortie :** une release peut être reproduite, vérifiée, installée et corrigée sans improvisation.

## Procédure de suivi automatique

À chaque cycle de suivi :

1. Lire cette roadmap et relever la première tâche non terminée dont les dépendances sont satisfaites.
2. Vérifier l'état GitHub (issues, PR, commits, CI et artefacts) avant d'agir.
3. Si un job est en cours ou en attente, surveiller et diagnostiquer ; ne pas créer de commits inutiles qui relancent la CI.
4. Si une correction autonome et sûre est possible, la préparer dans une branche/PR dédiée avec tests. Ne jamais fusionner automatiquement.
5. Si une action locale, une permission ou un périphérique physique est requis, signaler le blocage précisément et poursuivre les tâches indépendantes.
6. Après chaque résultat vérifié, mettre à jour les cases et le tableau de bord avec la preuve (PR, commit, run ou procédure).
7. Rapporter en français : terminé, en cours, bloqué, prochaine tâche et lien direct.

## Critères communs d'acceptation d'une PR

- Objectif, périmètre et risque clairement décrits.
- Diff minimal, relu et sans fichier généré inutile.
- Tests pertinents exécutés ; limites des tests matériels explicites.
- CI vérifiée sur toutes les cibles concernées ; un statut en attente n'est jamais assimilé à un succès.
- Documentation et traductions mises à jour si nécessaire.
- Compatibilité upstream, licence et attribution contrôlées.
- Aucune fusion avant validation complète et revue.

---

Cette roadmap est un plan évolutif. Les cases ne sont cochées qu'après validation factuelle ; les priorités peuvent changer si un bug bloquant ou une demande upstream importante apparaît.


### Suivi factuel — 13/11/2026

- PR #1 reste fusionnée dans `devel` : head historique `fix/linux-local-midi-dependency` = `b70b9ab3d710c4e8f7269fa8c0ba0bda68ab25e2`, merge `295fd10b688d36b0b06fc6aba6cb56d0e32c68a2`. Linux x86_64/ARM64, Windows MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont tous `success`. Les artefacts AppDir/AppImage Linux, installeurs MSVC et ZIP macOS existent.
- PR #2 : Linux ARM64, Windows, MSYS2 et macOS `success` ; Linux x86_64 `cancelled`, job `128671328713`, sans runner attribué ni étape.
- PR #3 : même état ; Linux ARM64 `success`, Linux x86_64 `cancelled`, job `128671944410`, sans runner ni étape. Le pin Drumstick est donc validé uniquement sur ARM64.
- PR #4 : Linux ARM64, Windows MSVC, MSYS2 et macOS `success` ; Linux x86_64 `cancelled`, job `129721316152`. Un ancien run x86_64 [42588964777](https://github.com/claudeia206/VMPK/actions/runs/42588964777) avait échoué pendant `VCPKG Build`, mais les logs sont inaccessibles (`404 BlobNotFound`) ; la cause n'est pas connue.
- PR #5 : Linux ARM64, Windows, MSYS2 et macOS `success` ; Linux x86_64 `cancelled`, job `129065748333`, sans runner ni étape. Le run `pull_request_target` vert utilise le workflow de la base et ne valide pas le fichier proposé dans la PR.
- PR #6, ancien head `3ff20e6d5582fa2ece61b861fcd02f7af02bdd45` : [run Linux 43184577292](https://github.com/claudeia206/VMPK/actions/runs/43184577292), ARM64 `failure` au smoke test ; `ldd` sans `LD_LIBRARY_PATH` rapporte `libQt6Network.so.6 => not found`. Le job x86_64 `131068461148` était `queued` sans runner. MSVC ARM64 et macOS x86_64 ont réussi avec artefacts ; MSVC x64, macOS ARM64, MSYS2 ucrt64 et clang64 ont été `cancelled` ; MSYS2 clangarm64 a réussi.
- PR #6, nouveau head `afe99591d99c3ae1f3d9a2709fd09ae863da02da` : [Linux run 43392579496](https://github.com/claudeia206/VMPK/actions/runs/43392579496), ARM64 `in_progress` au build Drumstick et x86_64 `queued` (job `131775791040`, aucun runner attribué). [MSVC 43392579570](https://github.com/claudeia206/VMPK/actions/runs/43392579570), [MSYS2 43392579477](https://github.com/claudeia206/VMPK/actions/runs/43392579477) et [macOS 43392579472](https://github.com/claudeia206/VMPK/actions/runs/43392579472) sont en cours ; aucun de ces jobs n'est compté comme succès.
- PR #7 [permissions Linux en lecture seule](https://github.com/claudeia206/VMPK/pull/7), head `586e36475fcad9c44f512e579f507da3a3244ca2` : ajoute uniquement `permissions: contents: read` au workflow Linux. La CI doit encore prouver que checkout et vcpkg fonctionnent sans `packages: read`.
- Audit des déclencheurs terminé : les quatre workflows de build utilisent `push` et `pull_request` vers `devel`/`master`, plus `workflow_dispatch` ; aucun déclencheur tag/release n'existe. Le workflow de branche utilise `pull_request_target`. Le run Linux de référence PR #1 déclarait `Contents: read`, `Metadata: read`, `Packages: read`; PR #7 vérifie la réduction à `contents: read`. Les permissions des workflows qui téléchargent Drumstick depuis le dépôt upstream restent à vérifier sans élargir les droits.
- Sur PR #6, le test isolé CMake 3.31.6 a montré que `install(IMPORTED_RUNTIME_ARTIFACTS)` peut ne copier que le lien SONAME si la cible importée est un lien symbolique. Le nouveau code utilise `file(COPY ... FOLLOW_SYMLINK_CHAIN)` sous `DESTDIR`, avec diagnostic des liens avant `ldd`. Ce correctif attend encore la CI VMPK.
- Blocage commun : les jobs Linux x86_64 self-hosted sont régulièrement `queued` puis `cancelled`, avec `runner_id=0`, nom de runner absent et aucune étape. L'état du service Linux Mint doit être contrôlé localement.
