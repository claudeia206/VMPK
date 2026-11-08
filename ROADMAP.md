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
| Stabilisation de la PR #1 et CI multiplateforme | P0 | Terminée le 07/11/2026 | PR #1 fusionnée ; Linux x86_64/ARM64, Windows MSVC/MSYS2 et macOS verts |
| Cohérence des workflows et dépendances | P0 | En cours | Déclencheurs et versions audités ; pin Drumstick Linux en validation CI ; dépendances Windows/macOS encore basées sur upstream `devel` |
| Documentation d'installation et dépannage | P1 | À faire | Procédure testée sur les plateformes prises en charge |
| Tests de non-régression | P1 | À faire | Tests automatisés utiles + scénarios manuels documentés |
| Bugs et fonctionnalités demandées | P2 | À planifier | Priorité confirmée par issues et faisabilité |
| UX, clavier et traductions | P2/P3 | À planifier | Changements vérifiés sans régression MIDI |
| Releases et maintenance | P3 | À planifier | Checklist et procédure de publication reproductibles |

## Phase 0 — Stabilisation et état des lieux (P0)

- [x] Établir une roadmap en phases avec critères de sortie.
- [x] Finaliser la [PR #1](https://github.com/claudeia206/VMPK/pull/1) : fusion squash le 07/11/2026, commit [295fd10](https://github.com/claudeia206/VMPK/commit/295fd10b688d36b0b06fc6aba6cb56d0e32c68a2).
- [x] Linux x86_64 : **success** sur le runner self-hosted Linux Mint `linux-UX303LA` ([run PR #1](https://github.com/claudeia206/VMPK/actions/runs/42338619625), job 128301115613).
- [x] Linux ARM64 : **success** sur runner GitHub `ubuntu-24.04-arm` ([run PR #1](https://github.com/claudeia206/VMPK/actions/runs/42338619625), job 128301115414).
- [x] Windows MSVC ([run](https://github.com/claudeia206/VMPK/actions/runs/42338619573)), Windows MSYS2 ([run](https://github.com/claudeia206/VMPK/actions/runs/42338619619)) et macOS ([run](https://github.com/claudeia206/VMPK/actions/runs/42338619626)) : tous les jobs requis terminés en **success** sur le head `b70b9ab`.
- [x] Examiner les logs de la PR #1 : aucun échec dans les runs finaux retenus. Les échecs de la PR #2 du 07/11 sont distincts et proviennent de son ancienne base : `Input required and not supplied: github_token` dans les workflows non mis à jour.
- [x] Vérifier les artefacts CI : Linux x86_64/ARM64 AppDir + AppImage, Windows MSVC x64/ARM64 installeurs, macOS x86_64/ARM64 ZIP. Inspection de structure effectuée sur AppDir tar.gz, AppImage ELF, installeur NSIS PE et bundle macOS ZIP. **L'installation/lancement réel reste à tester** en Phase 1.
- [x] Relire le diff de la PR #1 : changements CI ciblés, pas de changement fonctionnel VMPK.

**Preuves post-fusion :** [Linux](https://github.com/claudeia206/VMPK/actions/runs/42346786840) · [Windows MSVC](https://github.com/claudeia206/VMPK/actions/runs/42346786874) · [Windows MSYS2](https://github.com/claudeia206/VMPK/actions/runs/42346786828) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/42346787053) — tous **success** sur `devel` au commit de fusion.

**Critères de sortie :** les jobs requis sont terminés, les cibles Linux x86_64 et ARM64 sont vertes, les autres plateformes sont vertes ou leurs limites sont explicitement documentées ; la PR est prête pour revue. Aucune fusion automatique.

## Phase 1 — CI, compilation et packaging (P0)

- [x] Auditer les déclencheurs et permissions : workflows Linux/Windows/macOS sur push et PR vers `devel`/`master`, plus `workflow_dispatch` ; aucun déclencheur de tag n'est configuré (à prévoir dans la future procédure de release). Les logs CI montrent un `GITHUB_TOKEN` en lecture seule ; le workflow `pull_request_target` de vérification de branche ne checkout aucun code et n'effectue aucune écriture.
- [x] Vérifier les versions déclarées : CMake 4.4.x, C++17, Drumstick 2.11.2 ; Qt Linux 6.11.1 (épinglé temporairement), Windows MSVC 6.10.3, macOS 6.8.3, Qt 6 fourni par MSYS2. Les versions Qt ne sont pas uniformes entre plateformes.
- [ ] Vérifier la construction de Drumstick depuis une source/version déterministe sur Linux. La CI précédente clone la branche mobile `devel` ; cette PR propose de la fixer au commit upstream `23da19d05ad511bd9140a2d00eedead2ae5bac1a` (version CMake 2.11.2), sous réserve de validation CI.
- [x] Vérifier les workflows Windows/macOS : artefacts téléchargés depuis `pedrolcl/drumstick`, workflow/branche identifiés et fallback `${{ secrets.GH_PAT || github.token }}` présent. Les builds PR #1 ont réussi ; la sélection de l'artefact reste basée sur upstream `devel` et n'est pas encore reproductible au niveau du run.
- [ ] Vérifier les chemins d'installation, les bibliothèques partagées, plugins Qt et dépendances MIDI au runtime.
- [ ] Tester l'installation/lancement des paquets produits, pas seulement leur génération.
- [ ] Réduire les duplications YAML et ajouter des timeouts/cache seulement si cela améliore fiabilité ou durée sans masquer les erreurs.
- [ ] Documenter tout épinglage temporaire (ex. Qt 6.11.1) avec cause, date de réévaluation et condition de retrait.

**Critères de sortie :** builds reproductibles et artefacts vérifiés sur les plateformes annoncées ; aucun secret requis inutilement ; permissions minimales.

## Phase 2 — Documentation et installation (P1)

- [ ] Aligner README, CMake, workflows et dépendances sur les versions effectivement supportées.
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
