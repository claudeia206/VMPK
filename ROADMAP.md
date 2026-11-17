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
| Cohérence CI et dépendances | P0 | En cours — smoke test AppDir/AppImage Linux validé ; pin Drumstick et permissions Linux x86_64 encore à confirmer | PR #2/#3/#5/#7 x86_64 cancelled sans runner ; PR #4/#8 x86_64 queued sans runner visible |
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
- [ ] Valider les permissions minimales explicites : PR #5 propose `permissions: {}` pour `pull_request_target` ; PR #7 propose `contents: read` pour Linux. Le run ARM64 de PR #7 est vert ; la relance x86_64 est `queued` (job `132750642066`). Windows/MSYS2/macOS restent à auditer pour leurs téléchargements d'artefacts upstream.
- [x] Relever les versions et les écarts entre plateformes ; la matrice est documentée dans [docs/CI-BUILD-MATRIX.md](docs/CI-BUILD-MATRIX.md) (PR #4). Qt 5 est disponible via `USE_QT5` dans CMake mais non testé par les workflows CI actuels.
- [ ] Vérifier la construction de Drumstick depuis une source/version déterministe sur Linux. Le commit upstream fixe `23da19d05ad511bd9140a2d00eedead2ae5bac1a` existe dans `pedrolcl/drumstick` et compile sur ARM64 dans PR #3 ; la relance x86_64 est `queued` (job `132750626086`), sans étape ni runner attribué visible.
- [x] Vérifier les sources d'artefacts Drumstick Windows/macOS et le fallback `${{ secrets.GH_PAT || github.token }}` ; les builds PR #1 sont verts. La sélection upstream `devel` reste mobile et donc non reproductible au niveau du run.
- [x] Vérifier le runtime des AppDir/AppImage Linux : PR #6, head `da16f0e7e3ec0986965bb7e4c096da5a9c0977c8`, Linux x86_64 et ARM64 `success` ; `ldd` résout les bibliothèques Qt depuis `AppDir/usr/lib`, `AppRun --version` et l'AppImage `--appimage-extract-and-run --version` passent sous Xvfb ([run Linux](https://github.com/claudeia206/VMPK/actions/runs/43578697576)). Le test ne couvre pas un périphérique MIDI physique.
- [ ] Étendre les tests d'installation/lancement à Windows et macOS : le smoke test Linux AppDir/AppImage est validé dans PR #6 ; les installeurs MSVC et ZIP macOS sont produits mais leur installation/lancement post-packaging n'est pas encore testé. MSYS2 compile sans publier d'artefact.
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


### Suivi complémentaire — 13/11/2026, après le run 43392579496

- PR #6, head `afe99591d99c3ae1f3d9a2709fd09ae863da02da` : [run Linux 43392579496](https://github.com/claudeia206/VMPK/actions/runs/43392579496), job ARM64 `131775791467`, a échoué au step `Install`. Le log exact indique que `file COPY` tentait d'écrire `libQt6Network.so.6.11.1` dans `/usr/lib` et recevait `Permission denied`. La chaîne CMake avait deux antislashs avant `$ENV{DESTDIR}`, ce qui supprimait le préfixe AppDir lors de la génération du script d'installation.
- Correction poussée dans le nouveau head PR #6 `0f5efef461c1406ede7ac168fc91f2206312a0bf` : un seul antislash préserve l'expansion de `$ENV{DESTDIR}` au moment de l'installation. Test isolé CMake 3.31.6 : lien SONAME et fichier versionné copiés sous `DESTDIR/usr/lib`, aucun accès à `/usr/lib`.
- CI du head `0f5efef` : [Linux 43393381690](https://github.com/claudeia206/VMPK/actions/runs/43393381690), ARM64 `in_progress`, x86_64 `queued` (job `131778398184`, aucun runner attribué). [MSVC 43393381680](https://github.com/claudeia206/VMPK/actions/runs/43393381680) et [MSYS2 43393381678](https://github.com/claudeia206/VMPK/actions/runs/43393381678) sont `in_progress`; [macOS 43393381699](https://github.com/claudeia206/VMPK/actions/runs/43393381699) est en cours/attente par architecture. Le contrôle de branche [43393377980](https://github.com/claudeia206/VMPK/actions/runs/43393377980) est `success`. Aucun artefact du nouveau head n'est disponible.
- PR #7, head `586e36475fcad9c44f512e579f507da3a3244ca2` : Linux ARM64 `in_progress` à `VCPKG Build`, x86_64 `queued` sans runner (`131776904540`). Windows MSVC, MSYS2 et macOS sont encore en cours ; le contrôle de branche est `success`. Les logs du job Linux ARM64 sont momentanément inaccessibles (`404 BlobNotFound`) ; les étapes indiquent seulement que vcpkg est en cours. Le test des permissions `contents: read` n'est donc pas encore concluant.
- PR #4, head documentaire `fb504b1f024828772e770ed4aa11935011f8dae8` : Linux ARM64 `in_progress`, x86_64 `queued` sans runner (`131777376569`) ; Windows MSVC, MSYS2 et macOS en cours. Le contrôle de branche est `success`.
- Les jobs x86_64 queued ne possèdent ni `runner_id`, ni nom de runner, ni étape exécutée. Ne pas les assimiler à un échec de compilation ou à un succès.


### Suivi factuel — 14/11/2026

- PR #1 reste fusionnée : la branche historique `fix/linux-local-midi-dependency` pointe toujours sur le head `b70b9ab3d710c4e8f7269fa8c0ba0bda68ab25e2`, et le commit de fusion `295fd10b688d36b0b06fc6aba6cb56d0e32c68a2` est inchangé. Linux x86_64/ARM64, Windows MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont `success`.
- PR #4, head `f579619697be603b39c091f3d47ee735c3abe705` : Linux ARM64 `success`, Linux x86_64 `cancelled` (job `131779130443`, `runner_id=0`, aucun nom ni aucune étape). Windows MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont `success`. Artefacts AppDir/AppImage ARM64, installations/installeurs MSVC et ZIP macOS présents ; MSYS2 ne publie pas d'artefact.
- PR #7, head `586e36475fcad9c44f512e579f507da3a3244ca2` : Linux ARM64 `success`, Linux x86_64 `cancelled` (job `131776904540`, `runner_id=0`, aucune étape). Windows MSVC, MSYS2 et macOS sont `success`. Artefacts ARM64 AppDir/AppImage, MSVC et macOS présents. Le test `contents: read` est donc réussi sur ARM64 mais reste non validé sur x86_64.
- PR #6, head précédent `5206d9d0b2fde53aad295908d0214a1bf677d3c9` : [run Linux 43393919287](https://github.com/claudeia206/VMPK/actions/runs/43393919287), ARM64 `failure` au smoke test ; le log montre `libQt6Network.so.6` et son fichier versionné présents dans l'AppDir mais non résolus par `ldd` sans `LD_LIBRARY_PATH`. Le job x86_64 `131780153152` a été `cancelled`, `runner_id=0`, sans étape. Aucun artefact Linux n'a été produit. Windows MSVC, MSYS2 et macOS ont terminé en `success`, avec artefacts MSVC et macOS.
- Correction préparée dans PR #6, nouveau head `da16f0e7e3ec0986965bb7e4c096da5a9c0977c8` : `CreateAppImage.cmake` génère un script `AppRun` qui prépare `LD_LIBRARY_PATH` pour les dépendances transitives ; le smoke test vérifie le chemin de bibliothèques, lance `AppRun --version`, puis l'AppImage avec `--appimage-extract-and-run`. Test CMake isolé et syntaxe shell réussis ; **validation CI VMPK non terminée**.
- CI du nouveau head PR #6 au 14/11 : Linux ARM64 `in_progress`, Linux x86_64 `queued` (job `132398547971`, `runner_id=0`, aucun nom ni aucune étape), MSVC x64/ARM64 `in_progress`, MSYS2 clangarm64/ucrt64 `in_progress` et clang64 `queued`, macOS x86_64/ARM64 `in_progress`, contrôle de branche `success`. Runs : [Linux 43578697576](https://github.com/claudeia206/VMPK/actions/runs/43578697576), [MSVC 43578697552](https://github.com/claudeia206/VMPK/actions/runs/43578697552), [MSYS2 43578697675](https://github.com/claudeia206/VMPK/actions/runs/43578697675), [macOS 43578697518](https://github.com/claudeia206/VMPK/actions/runs/43578697518).
- PR #2, #3 et #5 n'ont pas de nouveau head depuis leur dernier contrôle : Linux x86_64 reste `cancelled` sans runner attribué ; ARM64 et les plateformes Windows/macOS étaient `success`. Le pin Drumstick de PR #3 n'est toujours validé que sur ARM64.
- Le blocage du runner Linux Mint est confirmé côté GitHub : les jobs x86_64 portent le label `self-hosted`, mais ont `runner_id=0`, nom vide et zéro étape. Cela ne permet pas de déduire l'état du service systemd local. Aucun job en attente/en cours n'est compté comme réussi.
- Aucune tâche P2/P3 n'a été démarrée. Les P0 AppDir, pin x86_64 et permissions x86_64 restent ouvertes ; la prochaine étape est de valider le nouveau smoke test ARM64, puis d'obtenir l'attribution du runner Linux Mint.

### Suivi factuel — 15/11/2026

- PR #1 : toujours closed / merged, head historique fix/linux-local-midi-dependency = b70b9ab3d710c4e8f7269fa8c0ba0bda68ab25e2, merge 295fd10b688d36b0b06fc6aba6cb56d0e32c68a2. La branche et son SHA n'ont pas changé.
- PR #6, head da16f0e7e3ec0986965bb7e4c096da5a9c0977c8 : tous les jobs Linux x86_64/ARM64, Windows MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont terminés en success. Le job Linux x86_64 132398547971 a tourné sur le runner Linux Mint local ; le job ARM64 132398548251 a réussi sur le runner GitHub. Le smoke test exécute ldd avec le chemin AppDir, AppRun --version et l'AppImage avec --appimage-extract-and-run --version sous Xvfb. [Linux](https://github.com/claudeia206/VMPK/actions/runs/43578697576) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43578697552) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43578697675) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43578697518).
- Artefacts PR #6 présents : AppDir x86_64 (ID 14109270827, 54 806 295 octets), AppImage x86_64 (ID 14109365678, 50 784 760 octets), AppDir ARM64 (ID 14108235421, 53 498 008 octets), AppImage ARM64 (ID 14107786861, 49 351 176 octets). Installeurs MSVC x64/ARM64 et ZIP macOS x86_64/ARM64 présents ; aucun artefact MSYS2.
- PR #4, head documentaire 1d18f3f53639b0f111a7f010aade4ecd05f41741 : tous les jobs Linux x86_64/ARM64, MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont terminés en success. [Linux](https://github.com/claudeia206/VMPK/actions/runs/43578894178) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43578894175) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43578894181) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43578894198). Artefacts Linux AppDir/AppImage pour les deux architectures, installeurs MSVC x64/ARM64 et ZIP macOS x86_64/ARM64 présents.
- PR #2, #3, #5 et #7 : les anciens jobs Linux x86_64 avaient été annulés sans runner ni étape. Relances ciblées effectuées sans commit : PR #2 job 132750619127, PR #3 job 132750626086, PR #5 job 132750633518, PR #7 job 132750642066. Au dernier contrôle, ces quatre jobs sont queued, sans étape exécutée ni runner attribué visible. Leurs jobs ARM64 et les jobs Windows/MSYS2/macOS des runs correspondants sont success. Ces relances ne sont ni des échecs de compilation ni des succès.
- PR #3 : le commit upstream épinglé 23da19d05ad511bd9140a2d00eedead2ae5bac1a a été confirmé existant dans [pedrolcl/drumstick](https://github.com/pedrolcl/drumstick/commit/23da19d05ad511bd9140a2d00eedead2ae5bac1a) ; sa validation VMPK reste complète uniquement sur ARM64 jusqu'au résultat de la relance x86_64.
- PR #7 : permissions contents: read validées sur ARM64 ; validation x86_64 en attente de la relance ci-dessus. PR #5 : la modification du workflow pull_request_target reste à valider sur sa propre version, le contrôle de base vert ne suffisant pas.
- Aucun test avec périphérique MIDI physique n'a été effectué. Aucun travail P2/P3 n'a commencé ; les P0 pin x86_64 et permissions x86_64 restent ouverts. Les P1 installation Windows/macOS et tests MIDI restent à faire.


### Suivi factuel — 16/11/2026

- PR #1 reste **closed / merged** : branche historique `fix/linux-local-midi-dependency` au head `b70b9ab3d710c4e8f7269fa8c0ba0bda68ab25e2`, commit de fusion [295fd10](https://github.com/claudeia206/VMPK/commit/295fd10b688d36b0b06fc6aba6cb56d0e32c68a2). Les jobs Linux x86_64/ARM64, MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont tous `success` ([Linux](https://github.com/claudeia206/VMPK/actions/runs/42338619625), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/42338619573), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/42338619619), [macOS](https://github.com/claudeia206/VMPK/actions/runs/42338619626)).
- PR #6, head `da16f0e7e3ec0986965bb7e4c096da5a9c0977c8`, reste validée sur toutes les cibles : Linux x86_64/ARM64, MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 `success`. Le smoke test vérifie `ldd`, `AppRun --version` et l'AppImage via `--appimage-extract-and-run --version` ([Linux](https://github.com/claudeia206/VMPK/actions/runs/43578697576), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43578697552), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43578697675), [macOS](https://github.com/claudeia206/VMPK/actions/runs/43578697518)). Artefacts Linux x86_64/ARM64 AppDir/AppImage présents ; les installeurs MSVC et ZIP macOS existent ; MSYS2 ne publie pas d'artefact.
- PR #4, head validé `b9a1285e65727a5cea919f8b05019aa7e51cd036` : Linux ARM64 `success` (job `132751544453`), Linux x86_64 `queued` (job `132751544633`, aucune étape et aucune attribution de runner visible). MSVC x64/ARM64, MSYS2 ucrt64/clang64/clangarm64 et macOS x86_64/ARM64 sont tous `success` ([Linux](https://github.com/claudeia206/VMPK/actions/runs/43694369669), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43694369625), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43694369639), [macOS](https://github.com/claudeia206/VMPK/actions/runs/43694369650)). Artefacts ARM64 AppDir/AppImage, quatre artefacts MSVC et deux ZIP macOS présents ; aucun artefact MSYS2. Le nouveau commit documentaire de cette branche doit encore repasser sa CI.
- PR #2/#3/#5/#7 : les relances Linux x86_64 restent `queued`, sans étape ni runner attribué visible : jobs `132750619127`, `132750626086`, `132750633518` et `132750642066` respectivement. Linux ARM64 est `success` sur les quatre runs ; MSVC, MSYS2 et macOS sont `success` sur leurs runs correspondants ([PR #2](https://github.com/claudeia206/VMPK/actions/runs/42461423279), [PR #3](https://github.com/claudeia206/VMPK/actions/runs/42461626903), [PR #5](https://github.com/claudeia206/VMPK/actions/runs/42589015261), [PR #7](https://github.com/claudeia206/VMPK/actions/runs/43392922388)).
- Les jobs x86_64 utilisent `runs-on: self-hosted` dans [le workflow Linux](.github/workflows/linux-build.yml). Pour les jobs encore `queued`, aucun runner/nom/étape n'est retourné par l'API des jobs ; il s'agit d'un blocage d'attribution, pas d'un échec de compilation. Le succès x86_64 de PR #6 le 14/11 prouve que le runner a fonctionné au moins une fois, pas qu'il est actuellement disponible.
- Aucune fusion effectuée. Le pin Drumstick x86_64, la validation x86_64 de `contents: read`, l'audit du jeton upstream et l'installation/lancement Windows/macOS restent ouverts. Aucun test MIDI avec périphérique physique n'est revendiqué.


### Correction du suivi — 16/11/2026, contrôle des relances x86_64

- Les relances Linux x86_64 des PR #2, #3, #5 et #7 ne sont plus `queued` : elles sont terminées en `cancelled` après attente, sans runner attribué et avec zéro étape exécutée. Jobs : `132750619127`, `132750626086`, `132750633518`, `132750642066`. Les runs Linux correspondants sont [PR #2](https://github.com/claudeia206/VMPK/actions/runs/42461423279), [PR #3](https://github.com/claudeia206/VMPK/actions/runs/42461626903), [PR #5](https://github.com/claudeia206/VMPK/actions/runs/42589015261), [PR #7](https://github.com/claudeia206/VMPK/actions/runs/43392922388). Ce sont des annulations de jobs non attribués, pas des échecs de compilation. Linux ARM64 et les jobs MSVC/MSYS2/macOS de ces PR sont `success`.
- PR #4, nouveau head documentaire `056fd0bff1573b83b7dea83679cec8d1ad913020` : contrôle de branche `success`; Linux x86_64 `queued` (job `133172754551`, aucune étape ni runner attribué visible), Linux ARM64 `in_progress` à `VCPKG Build` (job `133172754742`); MSVC x64/ARM64 et MSYS2 (3 environnements) `success`; macOS x86_64/ARM64 `in_progress`. Runs : [Linux](https://github.com/claudeia206/VMPK/actions/runs/43829994896), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43829994817), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43829994779), [macOS](https://github.com/claudeia206/VMPK/actions/runs/43829994763), [contrôle](https://github.com/claudeia206/VMPK/actions/runs/43829992130). Aucun artefact de ce nouveau head n'est encore disponible.
- PR #8, head `2badee225118994528e9fd9c1e52b42cc8c96950` : contrôle de branche `success`; Linux x86_64 `queued` (job `133175118043`, aucune étape ni runner attribué visible), Linux ARM64 `in_progress`; MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 `in_progress`. Les étapes smoke test Windows/macOS ne sont pas encore atteintes et aucun artefact n'est disponible. Runs : [Linux](https://github.com/claudeia206/VMPK/actions/runs/43830712460), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43830712410), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43830712413), [macOS](https://github.com/claudeia206/VMPK/actions/runs/43830712378), [contrôle](https://github.com/claudeia206/VMPK/actions/runs/43830712598).
- Les deux jobs x86_64 encore `queued` (PR #4 et #8) utilisent le label `self-hosted`, sans runner/nom/étape retourné par l'API. Les quatre relances précédentes sont désormais `cancelled`. L'état actuel du service Linux Mint reste à vérifier localement.
## Suivi du 17 novembre 2026

### PR #1 et branche historique

- [PR #1](https://github.com/claudeia206/VMPK/pull/1) est fermée et fusionnée depuis le 07/11/2026 ; head historique `b70b9ab3d710c4e8f7269fa8c0ba0bda68ab25e2`, commit de fusion [295fd10](https://github.com/claudeia206/VMPK/commit/295fd10b688d36b0b06fc6aba6cb56d0e32c68a2). La branche `fix/linux-local-midi-dependency` conserve ce head ; `devel` pointe sur le commit de fusion.
- Contrôle des runs de référence : Linux x86_64 et ARM64, Windows MSVC x64/ARM64, MSYS2 ucrt64/clang64/clangarm64 et macOS x86_64/ARM64 sont tous `success` ([Linux](https://github.com/claudeia206/VMPK/actions/runs/42338619625), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/42338619573), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/42338619619), [macOS](https://github.com/claudeia206/VMPK/actions/runs/42338619626)). Aucune revue GitHub formelle n'est enregistrée ; le diff a été examiné avant la fusion.

### CI de la PR documentaire #4 — head `224f0281def38b17169862aa40eb46ab3acc4405`

- Linux ARM64 : `success`, AppDir et AppImage disponibles ; Linux x86_64 : `queued`, job `133176034004`, label `self-hosted`, `runner_id=0`, nom vide et aucune étape ([run Linux](https://github.com/claudeia206/VMPK/actions/runs/43830995260)).
- Windows MSVC x64/ARM64 : `success`, répertoires d'installation et installeurs NSIS disponibles ([run](https://github.com/claudeia206/VMPK/actions/runs/43830995221)).
- Windows MSYS2 ucrt64/clang64/clangarm64 : `success`, aucun artefact de packaging publié ([run](https://github.com/claudeia206/VMPK/actions/runs/43830995322)).
- macOS x86_64/ARM64 : `success`, ZIP des bundles `.app` disponibles ([run](https://github.com/claudeia206/VMPK/actions/runs/43830995339)).
- Le job x86_64 n'a exécuté aucune étape : ne pas classer ce résultat comme succès ou échec de compilation. Le service local du runner doit être contrôlé sur Linux Mint.

### PR #8 — tests post-packaging Windows/macOS

- Head initial `2badee225118994528e9fd9c1e52b42cc8c96950` : Linux ARM64 `success`, Linux x86_64 `queued` sans runner ; MSYS2 (3 cibles) et macOS (2 architectures) `success`. Les deux jobs Windows MSVC ont échoué à `Smoke-test NSIS installer`, après compilation, installation NSIS et vérification de `vmpk.exe`/`platforms/qwindows.dll`.
- Les logs Windows montrent que le contrôle `$LASTEXITCODE` reçoit une valeur vide. Le code source `src/main.cpp` retourne 0 pour `--version`; l'échec identifié concerne donc la récupération du code de sortie dans le test PowerShell, pas une erreur de compilation démontrée.
- Correctif dans [commit `fa5ba8b`](https://github.com/claudeia206/VMPK/commit/fa5ba8b97e3f0da41ad646ffc3b4a317205584ae) : lancer le binaire installé avec `Start-Process -Wait -PassThru` et vérifier `Process.ExitCode`, en conservant stdout/stderr en cas d'échec.
- Nouveau head `fa5ba8b97e3f0da41ad646ffc3b4a317205584ae` : contrôle de branche `success`; Linux ARM64 `in_progress` à VCPKG Build ; Linux x86_64 `queued`, job `133909020010`, label `self-hosted`, `runner_id=null`, aucun runner ni étape ; MSVC x64/ARM64, MSYS2 (3 cibles) et macOS x86_64/ARM64 `in_progress`. Aucun artefact du nouveau head n'est encore disponible ([Linux](https://github.com/claudeia206/VMPK/actions/runs/44045192443), [MSVC](https://github.com/claudeia206/VMPK/actions/runs/44045192498), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/44045192390), [macOS](https://github.com/claudeia206/VMPK/actions/runs/44045192548), [contrôle](https://github.com/claudeia206/VMPK/actions/runs/44045199327)).

### Jeton de téléchargement Drumstick upstream

- La documentation de [`dawidd6/action-download-artifact@v27`](https://github.com/dawidd6/action-download-artifact/tree/v27) indique qu'un `github_token` est requis pour un artefact provenant d'un autre dépôt et mentionne un PAT avec le scope `public_repo` si nécessaire.
- Les workflows MSVC/MSYS2/macOS téléchargent depuis le dépôt public `pedrolcl/drumstick` et utilisent `secrets.GH_PAT || github.token`. La valeur et les permissions effectives du secret ne sont pas accessibles depuis cette connexion ; aucune modification de secret ni réduction/extension de permissions n'est effectuée. Action requise : vérifier que `GH_PAT` est limité à la lecture du dépôt public upstream (scope classique `public_repo`, ou jeton fine-grained avec accès de lecture nécessaire aux Actions de ce seul dépôt).

### Blocages P0 et prochaine action

- Le pin Drumstick de PR #3 et `permissions: contents: read` de PR #7 restent validés sur ARM64, mais non validés sur Linux x86_64 : les jobs correspondants ont été `cancelled` sans runner ni étape.
- Le runner Linux Mint doit être rendu disponible pour les jobs `self-hosted` x86_64 ; contrôler `sudo systemctl status actions.runner.claudeia206-VMPK.linux-UX303LA.service --no-pager` puis `sudo journalctl -u actions.runner.claudeia206-VMPK.linux-UX303LA.service -n 80 --no-pager`.
- Garder les tâches P0 ouvertes jusqu'à validation x86_64 et réussite des smoke tests Windows corrigés. Ne pas commencer P2/P3.