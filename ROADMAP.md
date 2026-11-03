# VMPK Roadmap

> Roadmap de travail pour le miroir [xcodeia/VMPK](https://github.com/xcodeia/VMPK). À ajuster selon les retours upstream et les résultats CI.

## Objectif

Faire évoluer VMPK de façon prudente et testable, en préservant l’architecture, les comportements MIDI et la compatibilité avec le projet upstream [pedrolcl/VMPK](https://github.com/pedrolcl/VMPK).

## Principes de contribution

- Travailler sur la branche `devel`; éviter les changements directs sur `master`.
- Préférer des PR petites, indépendantes et faciles à tester.
- Ne pas fusionner sans validation CI et revue du diff.
- Vérifier les demandes existantes upstream avant d’ajouter une fonctionnalité.
- Maintenir GPL-3.0, les attributions et les traductions.
- Éviter les changements de dépendances massifs ou les refactorisations sans bénéfice démontré.

## Phase 0 — État des lieux et mise en place (P0)

- [ ] Examiner la PR #1 : README Drumstick 2.10 → 2.11; vérifier les contrôles disponibles et la cohérence finale.
- [ ] Établir l’état de référence de la CI Linux x86_64/ARM64, Windows MSVC/MSYS2 et macOS.
- [ ] Vérifier déclencheurs, permissions, secrets et versions des GitHub Actions.
- [ ] Confirmer les dépendances supportées : CMake ≥ 3.16, C++17, Qt 6.2+ (Qt 5.9+ optionnel), Drumstick ≥ 2.11.
- [ ] Identifier les erreurs de build et warnings reproductibles avant toute modification.
- [ ] Clarifier les différences entre le miroir et le dépôt upstream.

**Sortie attendue :** état CI documenté et liste de problèmes reproductibles.

## Phase 1 — Compilation, CI et packaging (P0)

- [ ] Corriger les échecs Linux en premier, puis Windows et macOS, avec une PR par problème.
- [ ] Tester Qt 6 par défaut et Qt 5 via `USE_QT5`.
- [ ] Vérifier D-Bus et le filtre d’événements natifs Linux (X11/Wayland).
- [ ] Vérifier les chemins de plugins et bibliothèques Drumstick à l’installation.
- [ ] Vérifier les artefacts Linux, l’installation Windows et le bundle macOS.
- [ ] Améliorer les logs de configuration CMake lorsqu’ils sont insuffisants.

**Sortie attendue :** CI verte sur les plateformes supportées, ou limitations externes clairement identifiées.

## Phase 2 — Documentation et installation (P1)

- [ ] Aligner README, CMake et workflows sur les versions réelles des dépendances.
- [ ] Clarifier les procédures de build Qt 5/Qt 6.
- [ ] Documenter la configuration des ports MIDI virtuels par système.
- [ ] Ajouter un guide de dépannage : ALSA/permissions, périphérique absent, backend MIDI, plugins Qt.
- [ ] Vérifier les instructions de contribution et de développement.

**Sortie attendue :** un contributeur peut installer les dépendances, compiler et lancer VMPK à partir du README.

## Phase 3 — Tests et qualité (P1)

- [ ] Cartographier les composants testables et les tests déjà présents.
- [ ] Ajouter des tests unitaires aux fonctions isolables du matériel MIDI (mapping, transposition, paramètres).
- [ ] Tester la persistance des préférences et mappings clavier.
- [ ] Couvrir MIDI thru, connexions et contrôleurs lorsque l’architecture le permet.
- [ ] Documenter les tests manuels nécessitant un périphérique MIDI.
- [ ] Corriger les warnings sans modifier le comportement, par petites PR.

**Sortie attendue :** chaque changement fonctionnel dispose d’une validation reproductible.

## Phase 4 — Bugs et fonctionnalités TODO upstream (P2)

Les éléments ci-dessous proviennent de la liste TODO existante. Leur priorité doit être confirmée par l’usage, les issues upstream et la complexité technique.

1. [ ] Support cohérent des lettres majuscules/minuscules dans le mapping clavier.
2. [ ] Génération d’accords.
3. [ ] Arpeggiator.
4. [ ] Lecture de fichiers MIDI.
5. [ ] Séparation des canaux MIDI.
6. [ ] Séparation des points de note.
7. [ ] Support des accordéons chromatiques à cinq rangées.

Pour chaque fonctionnalité :
- rechercher les issues/discussions upstream et l’implémentation existante;
- définir les interactions UI, le comportement MIDI et les cas limites;
- proposer une PR autonome;
- ajouter tests ou scénario manuel;
- documenter toute divergence par rapport à upstream.

## Phase 5 — UX, clavier et traductions (P2/P3)

- [ ] Vérifier l’accessibilité clavier, le focus et les raccourcis.
- [ ] Vérifier les mappings internationaux (AZERTY/QWERTY et autres dispositions).
- [ ] Améliorer la lisibilité des touches et états MIDI sans dégrader les performances.
- [ ] Évaluer les améliorations visuelles des touches uniquement si elles apportent un bénéfice clair.
- [ ] Maintenir les traductions Qt Linguist et les préférences existantes.

## Phase 6 — Maintenance et releases (P3)

- [ ] Définir une stratégie de synchronisation avec upstream.
- [ ] Documenter les changements spécifiques au miroir.
- [ ] Préparer les notes de version pour les changements significatifs.
- [ ] Publier une release uniquement après validation CI et contrôle des dépendances.
- [ ] Maintenir une checklist de release et un plan de retour arrière.

## Ordre d’exécution recommandé

1. Valider la PR #1 et la cohérence des dépendances.
2. Auditer CI et packaging.
3. Corriger les problèmes de build reproductibles.
4. Améliorer documentation et installation.
5. Introduire tests de non-régression.
6. Traiter les fonctionnalités TODO une par une, en commençant par les petites et les plus demandées.

## Critères d’acceptation d’une PR

- Problème et périmètre clairement décrits.
- Diff minimal et revue des impacts.
- Build/tests pertinents exécutés.
- CI vérifiée; échecs externes expliqués.
- Documentation ou notes de changement mises à jour si nécessaire.
- Compatibilité upstream évaluée.

---

Cette roadmap est un plan de travail évolutif, pas un engagement de livraison. Les fonctionnalités TODO ne seront développées qu’après vérification du besoin et de leur pertinence par rapport à upstream.


## Point de vigilance CI : accès aux artefacts Drumstick

Les workflows Linux, Windows MSVC, Windows MSYS2 et macOS récupèrent des artefacts du dépôt upstream `pedrolcl/drumstick` avec l’action `dawidd6/action-download-artifact`. Ils référencent le secret `GH_PAT`.

- [ ] Vérifier dans les paramètres GitHub du dépôt que le secret `GH_PAT` est défini, valide et autorisé à lire les artefacts du dépôt upstream.
- [ ] Confirmer que les noms d’artefacts et les noms de workflows upstream correspondent aux versions publiées.
- [ ] En cas d’échec CI, distinguer clairement l’échec d’authentification/téléchargement de l’échec de compilation VMPK.
- [ ] Ne jamais remplacer ce secret par un jeton public ou exposer sa valeur dans les logs.
- [ ] Étudier à terme une méthode de récupération d’artefacts plus robuste (release upstream ou dépendance versionnée), sans compromettre la sécurité ni la reproductibilité.

À la date de cet audit, l’API GitHub du dépôt ne retourne aucune exécution récente des workflows. Cela ne prouve pas à lui seul que les workflows sont mal configurés : vérifier aussi leur activation et les permissions Actions dans les paramètres du dépôt.
