# Matrice CI et reproductibilité

> État vérifié le **13 novembre 2026**, sur la base de `devel` au commit [295fd10](https://github.com/claudeia206/VMPK/commit/295fd10b688d36b0b06fc6aba6cb56d0e32c68a2). Les versions listées sont celles déclarées dans les workflows, pas une promesse de support universel.

## Matrice de compilation

| Cible CI | Qt déclaré | CMake déclaré | Drumstick | Sorties de packaging |
|---|---|---|---|---|
| Linux x86_64 (runner self-hosted Linux Mint) | 6.11.1 | 4.4.x | Dans `devel`, compilation depuis la branche upstream mobile `devel`. Le pin proposé en PR #3 n'est pas encore validé sur cette architecture. | AppDir tar.gz + AppImage |
| Linux ARM64 (`ubuntu-24.04-arm`) | 6.11.1 | 4.4.x | Source construite localement. PR #3 propose le commit upstream `23da19d05ad511bd9140a2d00eedead2ae5bac1a` (Drumstick 2.11.2). | AppDir tar.gz + AppImage |
| Windows MSVC x64 / ARM64 | 6.10.3 | CMake fourni par l'action vcpkg ; version non épinglée explicitement dans ce workflow | Artefacts upstream `pedrolcl/drumstick`, workflow `win-msvc.yml`, branche `devel` | Répertoire d'installation + installeur NSIS |
| Windows MSYS2 ucrt64 / clang64 / clangarm64 | Qt 6 via les paquets MSYS2 `qt6-base`, `qt6-tools`, `qt6-translations` (versions rolling) | Paquet `cmake:p` MSYS2, version non épinglée | Artefacts upstream `pedrolcl/drumstick`, workflow `win-msys.yml`, branche `devel` | Compilation seulement ; packaging/upload actuellement commentés |
| macOS x86_64 / ARM64 | 6.8.3 | 4.4.x | Artefact upstream Drumstick via `mac-ci.yml` | ZIP de l'application `.app` |

## Prérequis déclarés par CMake

- CMake minimal : **3.16**.
- Standard C++ : **C++17**.
- Qt 6 : **6.2 ou supérieur** ; Qt 5 : **5.9 ou supérieur** via `USE_QT5=ON`.
- Drumstick : **2.11 ou supérieur**, composants RT et Widgets.
- Le workflow Linux Qt 6.11.1 installe aussi le module `qt5compat` pour Drumstick.

**Attention :** Qt 5 reste une option dans le code CMake, mais les workflows CI actuels ne valident pas la compilation Qt 5. Ne pas confondre compatibilité déclarée et matrice effectivement testée.

## Déclencheurs et permissions GitHub Actions

Les workflows de compilation Linux, Windows MSVC, Windows MSYS2 et macOS déclarent :

- `push` sur `devel` et `master` ;
- `pull_request` vers `devel` et `master` ;
- `workflow_dispatch`.

Le workflow `check-branches.yml` utilise `pull_request_target` pour contrôler la relation branches source/cible. Il ne checkout pas le code de la PR et n'exécute pas de commande issue de celle-ci. La PR #5 propose en plus `permissions: {}` et le passage des refs via des variables d'environnement ; le workflow sur `devel` n'intègre pas encore cette correction.

**État au 13/11 :** les workflows de build sur `devel` ne déclarent pas de bloc `permissions:`. Le run Linux PR #1 exposait `Contents: read`, `Metadata: read`, `Packages: read`. La PR #7 propose `permissions: contents: read` pour Linux ; sa CI doit confirmer que vcpkg fonctionne avec ce périmètre réduit. PR #5 propose `permissions: {}` pour le contrôle de branches, mais le correctif n'est pas encore intégré dans `devel`. Les workflows Windows/MSYS2/macOS qui téléchargent des artefacts du dépôt upstream restent à auditer : ne pas ajouter `actions: read` ou d'autres droits sans preuve qu'ils sont nécessaires.

Pour les téléchargements d'artefacts Drumstick Windows/macOS, les workflows utilisent le fallback `${{ secrets.GH_PAT || github.token }}`. Le secret `GH_PAT` n'est pas requis si le jeton intégré suffit, mais ses permissions effectives doivent rester limitées.

## Résultats CI et limites actuelles

- [PR #1](https://github.com/claudeia206/VMPK/pull/1), head `b70b9ab` : Linux x86_64 et ARM64, Windows MSVC, Windows MSYS2 et macOS terminés en **success**. [Linux](https://github.com/claudeia206/VMPK/actions/runs/42338619625) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/42338619573) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/42338619619) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/42338619626).
- [PR #2](https://github.com/claudeia206/VMPK/pull/2), head `d461603` : Linux ARM64, Windows MSVC, Windows MSYS2 et macOS réussis. Linux x86_64 a été **cancelled** après 24 h d'attente sans runner attribué : [run Linux](https://github.com/claudeia206/VMPK/actions/runs/42461423279), job `128671328713`, label `self-hosted`, `runner_id=0`, nom vide, aucune étape.
- [PR #3](https://github.com/claudeia206/VMPK/pull/3), head `6d6472b` : Linux ARM64, Windows MSVC, Windows MSYS2 et macOS réussis. Linux x86_64 a été **cancelled** après 24 h d'attente sans runner attribué : [run Linux](https://github.com/claudeia206/VMPK/actions/runs/42461626903), job `128671944410`, label `self-hosted`, `runner_id=0`, nom vide, aucune étape.
- [PR #4](https://github.com/claudeia206/VMPK/pull/4), head `65c5fb8` : Linux ARM64, Windows MSVC, MSYS2 et macOS **success** ; artefacts ARM64 AppDir/AppImage, MSVC x64/ARM64 (installations + installeurs) et ZIP macOS x86_64/ARM64 présents. Linux x86_64 **failure** pendant l'étape `VCPKG Build` ([run](https://github.com/claudeia206/VMPK/actions/runs/42588964777), job `129065572750)). Les logs sont inaccessibles : l'API renvoie `404 BlobNotFound`, et l'étape est encore signalée `in_progress` malgré la conclusion `failure`. La cause reste inconnue ; aucun artefact x86_64.
- [PR #5](https://github.com/claudeia206/VMPK/pull/5), head `b8b7750` : Linux ARM64, Windows MSVC, MSYS2 et macOS **success** ; artefacts ARM64 AppDir/AppImage, MSVC x64/ARM64 et ZIP macOS x86_64/ARM64 présents. Linux x86_64 **queued** ([run](https://github.com/claudeia206/VMPK/actions/runs/42589015261), job `129065748333`), sans étape ni runner indiqué. Le contrôle `pull_request_target` est vert mais exécute le workflow de la branche de base ; la modification de PR #5 n'est donc pas encore validée par ce contrôle.

Ces annulations ne sont **pas** des échecs de compilation ni des succès : le job n'a pas commencé et aucun log de build n'existe. GitHub n'a pas attribué de runner self-hosted à ces jobs. L'état local du service systemd ne peut pas être contrôlé depuis le dépôt.

### Contrôle local du runner Linux Mint

Sur la machine Linux Mint qui héberge le runner :

```bash
sudo systemctl status actions.runner.claudeia206-VMPK.linux-UX303LA.service --no-pager
sudo journalctl -u actions.runner.claudeia206-VMPK.linux-UX303LA.service -n 80 --no-pager
```

Si le service est arrêté, vérifier la cause dans le journal avant de le redémarrer. Ne pas relancer à l'aveugle les jobs GitHub : tant que le runner n'est pas disponible, ils peuvent rester en attente puis être annulés.

## Packaging : niveau de validation

- Linux : AppDir archive et AppImage.
- Windows MSVC : répertoire installé et installeur NSIS.
- macOS : ZIP contenant le bundle `.app`.
- MSYS2 : pas d'artefact de packaging dans le workflow actuel.

Les artefacts de PR #1 ont été inspectés structurellement (format/présence des fichiers). **L'installation et le lancement réel de chaque paquet restent à tester** ; aucun test MIDI avec périphérique physique n'est couvert par cette matrice.

## Épinglage temporaire de Qt Linux

Qt Linux est temporairement épinglé à **6.11.1** : le workflow documente un problème de détection ZIP d'aqtinstall avec Python 3.12 pour Qt 6.11.2. Réévaluer ce pin à la prochaine revue CI après passage du runner à Python 3.14 ou correction vérifiée d'aqtinstall. État de référence : **09/11/2026**.

## Sources à maintenir à jour

- [Workflow Linux](../.github/workflows/linux-build.yml)
- [Workflow Windows MSVC](../.github/workflows/win-msvc-ci.yml)
- [Workflow Windows MSYS2](../.github/workflows/win-msys2-ci.yml)
- [Workflow macOS](../.github/workflows/mac-ci.yml)
- [ROADMAP](../ROADMAP.md)


## Suivi du 13 novembre 2026

### PR #6 — runtime AppDir Linux

- Head précédent `3ff20e6` : [run Linux 43184577292](https://github.com/claudeia206/VMPK/actions/runs/43184577292), job ARM64 `131068461017` en `failure` au step `Smoke-test installed AppDir`. Le log `ldd` montre `libQt6Network.so.6 => not found`, malgré les messages d'installation CMake des fichiers Qt Network. Le job x86_64 `131068461148` est resté `queued`, sans runner attribué. Aucun artefact Linux.
- Le même head a produit MSVC ARM64 et macOS x86_64 en `success` avec artefacts ; MSVC x64, macOS ARM64, MSYS2 ucrt64 et clang64 ont été `cancelled`, et MSYS2 clangarm64 a réussi.
- Nouveau head `afe99591d99c3ae1f3d9a2709fd09ae863da02da` : [Linux 43392579496](https://github.com/claudeia206/VMPK/actions/runs/43392579496) ARM64 `in_progress` au build Drumstick ; x86_64 `queued` (job `131775791040`, runner non attribué). [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43392579570), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43392579477) et [macOS](https://github.com/claudeia206/VMPK/actions/runs/43392579472) sont encore en cours.
- Le code copie la chaîne de liens Qt Network via `file(COPY ... FOLLOW_SYMLINK_CHAIN)` sous `DESTDIR`. Test isolé CMake 3.31.6 réussi ; validation CI VMPK encore en attente.

### PR #7 — permissions Linux

[PR #7](https://github.com/claudeia206/VMPK/pull/7) ajoute `permissions: contents: read` au workflow Linux uniquement. La CI doit confirmer que les étapes checkout/vcpkg n'ont pas besoin de permissions supplémentaires. Les autres workflows restent inchangés tant que les besoins du téléchargement upstream ne sont pas démontrés.


### Mise à jour CI — 13/11/2026, après correction DESTDIR

- PR #6 head `afe9959` : échec démontré à `Install`, car le code CMake tentait d'écrire dans `/usr/lib` (permission refusée) au lieu de `DESTDIR/usr/lib`. Correction d'un antislash en trop dans le code CMake, commit [0f5efef](https://github.com/claudeia206/VMPK/commit/0f5efef461c1406ede7ac168fc91f2206312a0bf).
- Test isolé CMake 3.31.6 réussi : `FOLLOW_SYMLINK_CHAIN` installe le lien `libQt6Network.so.6` et son fichier versionné dans `DESTDIR/usr/lib`, sans toucher à `/usr/lib`.
- Nouveau head PR #6 : [Linux](https://github.com/claudeia206/VMPK/actions/runs/43393381690) ARM64 `in_progress`, x86_64 `queued` sans runner ; [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43393381680), [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43393381678) et [macOS](https://github.com/claudeia206/VMPK/actions/runs/43393381699) en cours/attente. Contrôle de branche `success`. Aucun artefact du nouveau head.
- PR #7 : Linux ARM64 `in_progress` au step `VCPKG Build`, x86_64 `queued` sans runner ; Windows/MSYS2/macOS en cours. Les logs Linux sont indisponibles pour l'instant ; aucune conclusion sur les permissions réduites avant la fin de la CI.
- PR #4 head documentaire : Linux ARM64 `in_progress`, x86_64 `queued` sans runner ; autres plateformes en cours. Les jobs en cours ou en attente ne sont pas des succès.
