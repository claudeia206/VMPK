# Matrice CI et reproductibilité

> État vérifié le **15 novembre 2026**, sur la base de `devel` au commit [295fd10](https://github.com/claudeia206/VMPK/commit/295fd10b688d36b0b06fc6aba6cb56d0e32c68a2). Les versions listées sont celles déclarées dans les workflows, pas une promesse de support universel. Les résultats par PR sont datés dans les sections de suivi ci-dessous.

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


## Suivi du 14 novembre 2026

### PR #4 — head documentaire `f579619`

- Linux ARM64 : `success` ; Linux x86_64 : `cancelled`, job `131779130443`, `runner_id=0`, aucune étape.
- Windows MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 : `success`.
- Artefacts présents : AppDir tar.gz + AppImage ARM64, installations/installeurs MSVC x64/ARM64, ZIP macOS x86_64/ARM64. Aucun artefact MSYS2.
- [Run Linux](https://github.com/claudeia206/VMPK/actions/runs/43393603814) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43393603659) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43393603652) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43393603868).

### PR #7 — permissions Linux `contents: read`

- Linux ARM64 : `success` ; Linux x86_64 : `cancelled`, job `131776904540`, `runner_id=0`, aucune étape.
- Windows MSVC, MSYS2 et macOS : `success`.
- Artefacts présents : AppDir/AppImage ARM64, installations/installeurs MSVC et ZIP macOS. Aucun artefact MSYS2.
- La réduction à `contents: read` est validée sur ARM64 ; l'architecture x86_64 reste non testée.
- [Run Linux](https://github.com/claudeia206/VMPK/actions/runs/43392922388) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43392922399) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43392922203) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43392922586).

### PR #6 — smoke test AppDir/AppImage

- Le [run Linux 43393919287](https://github.com/claudeia206/VMPK/actions/runs/43393919287), head `5206d9d`, a échoué sur ARM64 au step `Smoke-test installed AppDir`. Les fichiers Qt Network sont présents dans l'AppDir, mais `ldd` sans `LD_LIBRARY_PATH` ne résout pas `libQt6Network.so.6`. Le job x86_64 a été annulé sans runner ni étape ; aucun artefact Linux.
- Le nouveau head `da16f0e` ajoute un `AppRun` shell qui prépare `LD_LIBRARY_PATH`, teste le binaire via `AppRun --version` et lance l'AppImage avec `--appimage-extract-and-run`. Cette correction reste en validation.
- CI du nouveau head : Linux ARM64 `in_progress`, Linux x86_64 `queued` (job `132398547971`, aucun runner attribué), MSVC x64/ARM64 `in_progress`, MSYS2 clangarm64/ucrt64 `in_progress` et clang64 `queued`, macOS x86_64/ARM64 `in_progress`, contrôle de branche `success`.
- [Linux 43578697576](https://github.com/claudeia206/VMPK/actions/runs/43578697576) · [MSVC 43578697552](https://github.com/claudeia206/VMPK/actions/runs/43578697552) · [MSYS2 43578697675](https://github.com/claudeia206/VMPK/actions/runs/43578697675) · [macOS 43578697518](https://github.com/claudeia206/VMPK/actions/runs/43578697518).

### Blocage self-hosted

Les jobs Linux x86_64 récents sont en attente ou annulés avec le label `self-hosted`, `runner_id=0`, aucun nom et aucune étape. Il faut contrôler le service Linux Mint localement ; GitHub seul ne permet pas d'affirmer qu'il est arrêté.

## Résultats actualisés — 15 novembre 2026

### PR #6 — AppDir/AppImage Linux, head da16f0e

- Tous les jobs sont terminés en success : Linux x86_64 (runner self-hosted Linux Mint, job 132398547971), Linux ARM64 (132398548251), MSVC x64/ARM64, MSYS2 clangarm64/ucrt64/clang64 et macOS x86_64/ARM64.
- Le smoke test Linux a vérifié que ldd résout les dépendances Qt dans AppDir/usr/lib, puis exécuté AppRun --version et l'AppImage avec --appimage-extract-and-run --version sous Xvfb, avec les variables Qt externes neutralisées.
- [Run Linux](https://github.com/claudeia206/VMPK/actions/runs/43578697576) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43578697552) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43578697675) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43578697518).
- Artefacts Linux présents et non expirés : AppDir x86_64 ID 14109270827 (54 806 295 octets), AppImage x86_64 ID 14109365678 (50 784 760 octets), AppDir ARM64 ID 14108235421 (53 498 008 octets), AppImage ARM64 ID 14107786861 (49 351 176 octets). Les installeurs MSVC x64/ARM64 et ZIP macOS x86_64/ARM64 sont également présents ; MSYS2 n'a pas d'artefact.
- Limite : le test lance VMPK avec --version sous Xvfb ; il ne valide pas une connexion à un périphérique MIDI physique ni le MIDI thru.

### PR #4 — documentation, head 1d18f3f

- Tous les jobs Linux x86_64/ARM64, Windows MSVC x64/ARM64, MSYS2 (3 environnements) et macOS x86_64/ARM64 sont terminés en success.
- [Linux](https://github.com/claudeia206/VMPK/actions/runs/43578894178) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43578894175) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43578894181) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43578894198).
- Artefacts Linux AppDir/AppImage pour x86_64 et ARM64, installeurs MSVC x64/ARM64 et ZIP macOS x86_64/ARM64 présents ; aucun artefact MSYS2.

### Relances Linux x86_64 ciblées — PR #2, #3, #5 et #7

Les anciens jobs x86_64 avaient été annulés sans runner attribué ni étape. Après le succès du runner Linux Mint sur PR #6, les quatre jobs annulés ont été relancés individuellement, sans commit ni modification de code :

| PR | Job de la relance | État au dernier contrôle |
|---|---:|---|
| [#2](https://github.com/claudeia206/VMPK/pull/2) | 132750619127 | queued, aucune étape, aucun runner attribué visible |
| [#3](https://github.com/claudeia206/VMPK/pull/3) | 132750626086 | queued, aucune étape, aucun runner attribué visible |
| [#5](https://github.com/claudeia206/VMPK/pull/5) | 132750633518 | queued, aucune étape, aucun runner attribué visible |
| [#7](https://github.com/claudeia206/VMPK/pull/7) | 132750642066 | queued, aucune étape, aucun runner attribué visible |

- Les jobs ARM64 et les jobs Windows/MSYS2/macOS des runs précédents sont success. Les relances x86_64 restent en attente : elles ne sont ni des échecs de compilation ni des succès.
- PR #3 : le commit upstream épinglé 23da19d05ad511bd9140a2d00eedead2ae5bac1a existe dans [pedrolcl/drumstick](https://github.com/pedrolcl/drumstick/commit/23da19d05ad511bd9140a2d00eedead2ae5bac1a) ; validation de compilation VMPK confirmée sur ARM64 seulement en attendant le job x86_64.
- PR #7 : permissions contents: read validées sur ARM64 ; x86_64 en attente.
- Le runner self-hosted Linux Mint a bien exécuté le job x86_64 de PR #6 le 14/11. Les nouvelles relances sont de nouveau queued le 15/11 ; vérifier le journal systemd si elles ne sont pas attribuées.



## Contrôle complémentaire — 16 novembre 2026

- PR #4, head `b9a1285e65727a5cea919f8b05019aa7e51cd036` : Linux ARM64 `success`, job `132751544453` ; Linux x86_64 `queued`, job `132751544633`, sans étape ni attribution de runner visible. MSVC x64/ARM64, MSYS2 ucrt64/clang64/clangarm64 et macOS x86_64/ARM64 sont `success`. [Linux](https://github.com/claudeia206/VMPK/actions/runs/43694369669) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43694369625) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43694369639) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43694369650).
- Artefacts PR #4 non expirés : AppDir ARM64 `14153647051` (53 502 402 octets), AppImage ARM64 `14153208053` (49 351 176 octets), MSVC ARM64 `14153768307`, installeur ARM64 `14153568915`, installeur x64 `14153492394`, installation x64 `14153412537`, ZIP macOS x86_64 `14154266371` et ARM64 `14154062053`. Aucun artefact MSYS2 ni x86_64 Linux sur ce run.
- PR #6, head `da16f0e7e3ec0986965bb7e4c096da5a9c0977c8` : tous les jobs et smoke tests Linux x86_64/ARM64 sont `success` ; artefacts AppDir/AppImage pour les deux architectures, MSVC et macOS disponibles. [Run Linux](https://github.com/claudeia206/VMPK/actions/runs/43578697576).
- PR #2/#3/#5/#7 : les relances ciblées x86_64 `132750619127`, `132750626086`, `132750633518` et `132750642066` sont toujours `queued`, sans étapes ni runner attribué visible. Les jobs ARM64, MSVC, MSYS2 et macOS correspondants sont `success`. Une attente sans runner n'est ni un succès ni un échec de compilation.
- Le workflow Linux déclare `runs-on: self-hosted` pour x86_64 et `ubuntu-24.04-arm` pour ARM64. Le runner Linux Mint a exécuté le job PR #6 le 14/11 ; son état systemd actuel doit être contrôlé localement si les files d'attente persistent.
- Le nouveau commit documentaire PR #4 créé avec cette mise à jour n'a pas encore de résultat CI ; les statuts ci-dessus se rapportent au parent `b9a1285`.


## Correction des statuts — 16 novembre 2026

- Les relances Linux x86_64 des PR #2/#3/#5/#7 ont expiré/été annulées : jobs `132750619127`, `132750626086`, `132750633518`, `132750642066` en `cancelled`, zéro étape et aucun runner attribué. Les jobs ARM64 et les autres plateformes de ces PR sont `success`.
- PR #4, head `056fd0bff1573b83b7dea83679cec8d1ad913020` : Linux x86_64 `queued`, Linux ARM64 `in_progress`, MSVC et MSYS2 `success`, macOS `in_progress`. [Linux](https://github.com/claudeia206/VMPK/actions/runs/43829994896) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43829994817) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43829994779) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43829994763).
- PR #8, head `2badee225118994528e9fd9c1e52b42cc8c96950` : Linux x86_64 `queued`, Linux ARM64 `in_progress`, MSVC/MSYS2/macOS `in_progress`. Les smoke tests post-installation ne sont pas encore atteints. [Linux](https://github.com/claudeia206/VMPK/actions/runs/43830712460) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43830712410) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43830712413) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43830712378).
- Les jobs x86_64 en attente ne disposent d'aucun runner/nom/étape visible. Ne pas les assimiler à un échec de compilation ni à un succès.
## État vérifié le 17 novembre 2026

### PR #4 — head `224f0281def38b17169862aa40eb46ab3acc4405`

| Cible | État | Artefacts vérifiés |
|---|---|---|
| Linux x86_64 | `queued` — job `133176034004`, `runner_id=0`, aucune étape | Aucun |
| Linux ARM64 | `success` | AppDir tar.gz + AppImage |
| Windows MSVC x64/ARM64 | `success` | Répertoires d'installation + installeurs NSIS |
| Windows MSYS2 ucrt64/clang64/clangarm64 | `success` | Aucun artefact publié |
| macOS x86_64/ARM64 | `success` | ZIP `.app` |

Liens : [Linux](https://github.com/claudeia206/VMPK/actions/runs/43830995260) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/43830995221) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/43830995322) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/43830995339). Les artefacts Linux x86_64 manquent parce que le job n'a jamais reçu de runner ; ce n'est pas un échec de build.

### PR #8 — smoke tests Windows/macOS

- Head initial `2badee225118994528e9fd9c1e52b42cc8c96950` : macOS x86_64/ARM64 et MSYS2 ucrt64/clang64/clangarm64 `success`; Linux ARM64 `success`, Linux x86_64 `queued`; Windows MSVC x64/ARM64 `failure` à l'étape `Smoke-test NSIS installer`.
- Diagnostic des logs : le contrôle PowerShell reçoit `$LASTEXITCODE` vide après l'appel à l'application GUI ; les vérifications d'installation et du plugin `qwindows.dll` avaient réussi. Le test a été corrigé dans [commit `fa5ba8b`](https://github.com/claudeia206/VMPK/commit/fa5ba8b97e3f0da41ad646ffc3b4a317205584ae) avec `Start-Process -Wait -PassThru` et `Process.ExitCode`.
- Nouveau head `fa5ba8b97e3f0da41ad646ffc3b4a317205584ae` : Linux ARM64 `in_progress`; Linux x86_64 `queued`, job `133909020010`, sans runner ni étape ; MSVC x64/ARM64, MSYS2 (3 cibles) et macOS x86_64/ARM64 `in_progress`. Aucun artefact du nouveau head n'est encore disponible.
- Runs : [Linux](https://github.com/claudeia206/VMPK/actions/runs/44045192443) · [MSVC](https://github.com/claudeia206/VMPK/actions/runs/44045192498) · [MSYS2](https://github.com/claudeia206/VMPK/actions/runs/44045192390) · [macOS](https://github.com/claudeia206/VMPK/actions/runs/44045192548) · [contrôle de branche](https://github.com/claudeia206/VMPK/actions/runs/44045199327).

### Jeton d'accès aux artefacts upstream

La documentation de [`dawidd6/action-download-artifact@v27`](https://github.com/dawidd6/action-download-artifact/tree/v27) précise qu'un jeton est requis pour télécharger depuis un autre dépôt et recommande un PAT `public_repo` si nécessaire. Le secret `GH_PAT` n'est pas inspectable ici ; son périmètre doit être confirmé comme accès en lecture limité à `pedrolcl/drumstick`. Aucun secret ni permission n'a été modifié.

Les PR #3 (pin Drumstick) et #7 (`contents: read`) restent bloquées pour Linux x86_64 par le runner self-hosted non attribué. Les tâches P0 restent ouvertes ; aucun statut `queued` ou `in_progress` n'est compté comme succès.