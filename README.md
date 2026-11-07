# Virtual MIDI Piano Keyboard

[![Linux CI](https://github.com/claudeia206/VMPK/actions/workflows/linux-build.yml/badge.svg)](https://github.com/claudeia206/VMPK/actions/workflows/linux-build.yml)  
[![Windows MSVC CI](https://github.com/claudeia206/VMPK/actions/workflows/win-msvc-ci.yml/badge.svg)](https://github.com/claudeia206/VMPK/actions/workflows/win-msvc-ci.yml)  
[![Windows MSYS2 CI](https://github.com/claudeia206/VMPK/actions/workflows/win-msys2-ci.yml/badge.svg)](https://github.com/claudeia206/VMPK/actions/workflows/win-msys2-ci.yml)  
[![macOS CI](https://github.com/claudeia206/VMPK/actions/workflows/mac-ci.yml/badge.svg)](https://github.com/claudeia206/VMPK/actions/workflows/mac-ci.yml)

VMPK (Virtual MIDI Piano Keyboard) est un générateur et récepteur d’événements MIDI. Il ne produit pas de son lui-même, mais permet de piloter un synthétiseur MIDI matériel ou logiciel, interne ou externe. Vous pouvez jouer des notes MIDI avec le clavier de l’ordinateur ou la souris. VMPK peut également afficher les notes reçues d’un autre instrument ou d’un lecteur de fichiers MIDI : il suffit de connecter le port MIDI de cet autre logiciel au port d’entrée de VMPK.

![Capture d’écran](https://vmpk.sourceforge.io/images/vmpk_0.8_linux.png "Fenêtre principale")

[![Vidéo de présentation sur YouTube](https://img.youtube.com/vi/3TGNSYKjEtg/0.jpg)](https://www.youtube.com/watch?v=3TGNSYKjEtg)

VMPK a été testé sous Linux, Windows et macOS. Il peut éventuellement être compilé sur d’autres systèmes ; les contributions permettant de tester ces plateformes sont les bienvenues.

Le clavier virtuel [vkeybd de Takashi Iway](https://github.com/tiwai/vkeybd) a inspiré ce projet. C’est un excellent logiciel qui nous a rendu service pendant de nombreuses années. Merci !

VMPK utilise le framework graphique Qt et la bibliothèque Drumstick-RT pour les entrées/sorties MIDI. Ces deux projets sont libres et multiplateformes.

La correspondance entre les touches alphanumériques et les notes peut être configurée dans l’application. Les paramètres sont enregistrés dans des fichiers XML. Des mappings pour les dispositions espagnole, allemande et française sont fournis. Il est également possible de définir des mappings clavier bruts, en associant des codes de touches X11, Windows ou macOS à des notes MIDI.

VMPK peut envoyer des changements de programme et des contrôleurs à un synthétiseur MIDI. Les définitions des instruments et périphériques peuvent être fournies au format .INS, également utilisé par QTractor et TSE3, format développé par Cakewalk et utilisé notamment dans Sonar.

Le logiciel continue d’évoluer. Consultez le fichier [TODO](TODO) pour connaître les fonctionnalités en attente. Les questions, rapports de bogues et propositions d’amélioration sont les bienvenus.

Pour plus d’informations, consultez le [site officiel de VMPK](https://vmpk.sourceforge.io).

## Développement du dépôt xcodeia/VMPK

Le dépôt [xcodeia/VMPK](https://github.com/xcodeia/VMPK) est un miroir de travail du projet VMPK. Les évolutions doivent préserver le comportement MIDI, la compatibilité avec le projet [upstream](https://github.com/pedrolcl/VMPK) et la licence GPL-3.0.

La feuille de route complète, maintenue en français, est disponible ici :

➡️ **[Consulter la roadmap de développement](ROADMAP.md)**

### Priorités de développement

1. **État des lieux et CI** : vérifier les builds Linux (x86_64 et ARM64), Windows (MSVC et MSYS2) et macOS, ainsi que les versions et permissions des workflows.
2. **Compilation et packaging** : corriger les problèmes reproductibles plateforme par plateforme, vérifier Qt 6 et la compatibilité Qt 5, puis contrôler les installations et artefacts.
3. **Documentation et installation** : harmoniser le README, CMake et les workflows ; documenter la configuration MIDI et les problèmes fréquents.
4. **Tests et qualité** : renforcer les tests de non-régression pour les mappings clavier, les préférences, la transposition et les fonctions MIDI.
5. **Fonctionnalités TODO** : étudier puis traiter séparément les demandes existantes, notamment la génération d’accords, l’arpégiateur, la lecture de fichiers MIDI, la séparation des canaux et les mappings clavier.
6. **Expérience utilisateur et maintenance** : améliorer l’accessibilité clavier, les dispositions internationales, les traductions et la synchronisation avec upstream.

### Principes de contribution

- Travailler sur la branche `devel` et privilégier des changements ciblés.
- Préparer des PR petites, indépendantes et faciles à vérifier.
- Ne pas fusionner sans revue et validation CI lorsque celle-ci est disponible.
- Vérifier les demandes et solutions existantes upstream avant de développer une nouvelle fonctionnalité.
- Préserver la licence, les attributions, les traductions et la compatibilité multiplateforme.

Cette roadmap est un plan de travail évolutif : les priorités pourront être ajustées en fonction des résultats CI, des retours utilisateurs et de l’activité upstream.

## TÉLÉCHARGEMENT

La dernière version publiée est disponible sur SourceForge :

https://sourceforge.net/projects/vmpk/files

[![Télécharger Virtual MIDI Piano Keyboard](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/vmpk/files/latest/download)

[<img width='240' alt='Télécharger sur Flathub' src='https://dl.flathub.org/assets/badges/flathub-badge-en.png'/>](https://flathub.org/apps/details/net.sourceforge.VMPK)

[![État des paquets](https://repology.org/badge/tiny-repos/vmpk.svg)](https://repology.org/project/vmpk/versions)

## DÉPENDANCES

- **Qt 6.2 ou supérieur** (Qt 5.9 ou supérieur est également pris en charge). Installez les paquets de développement de votre distribution ou téléchargez l’édition libre : https://www.qt.io/download
- **Drumstick 2.11 ou supérieur**, utilisé pour les entrées/sorties MIDI. Drumstick s’appuie sur ALSA Sequencer sous Linux, WinMM sous Windows et CoreMIDI sous macOS : https://drumstick.sourceforge.net
- **CMake 3.16 ou supérieur** : https://cmake.org
- Un compilateur compatible **C++17**, par exemple GCC ou MinGW.
- Facultativement, **NSIS** permet de créer un programme d’installation Windows : https://nsis.sourceforge.io/

## INSTALLATION ET COMPILATION

Téléchargez les sources depuis https://sourceforge.net/projects/vmpk/files, décompressez l’archive puis placez-vous dans le répertoire extrait.

```sh
tar xvf vmpk-x.y.z.tar.gz
mkdir vmpk-x.y.z-build
```

CMake est la méthode recommandée. QMake reste disponible principalement pour les tests et le développement.

```sh
cmake -S vmpk-x.y.z -B vmpk-x.y.z-build
# ou, selon vos préférences :
ccmake -S vmpk-x.y.z -B vmpk-x.y.z-build
cmake-gui -S vmpk-x.y.z -B vmpk-x.y.z-build
```

Compilez le programme :

```sh
cmake --build vmpk-x.y.z-build
```

Si la compilation réussit, installez-le :

```sh
cmake --install vmpk-x.y.z-build
```

Les cibles suivantes sont également disponibles :

```sh
cmake --build vmpk-x.y.z-build --target uninstall
cmake --build vmpk-x.y.z-build --target clean
```

### Compilation optimisée

Vous pouvez choisir le type de compilation CMake :

```sh
cmake -S vmpk-x.y.z -B vmpk-x.y.z-build -DCMAKE_BUILD_TYPE=Release
```

Le type `Release` utilise généralement les options `-O3 -DNDEBUG`. Les autres types prédéfinis sont `Debug`, `RelWithDebInfo` et `MinSizeRel`.

Vous pouvez aussi définir vos propres options de compilation :

```sh
export CXXFLAGS="-O2 -march=native -mtune=native -DNDEBUG"
cmake -S vmpk-x.y.z -B vmpk-x.y.z-build
```

Adaptez ces options à votre système.

Pour installer VMPK ailleurs que dans le répertoire par défaut (`/usr/local`) :

```sh
cmake -S vmpk-x.y.z -B vmpk-x.y.z-build -DCMAKE_INSTALL_PREFIX=/usr
```

### Options CMake

- `ENABLE_DBUS` : active l’interface D-Bus, activée par défaut sous Linux.
- `EMBED_TRANSLATIONS` : embarque les traductions dans l’exécutable sous forme de ressources. Désactivée par défaut ; utile pour les versions portables.
- `BUILD_DOCS` : génère la page de manuel depuis les sources XML (activée par défaut). Si elle est désactivée, la page de manuel précompilée de l’archive source est installée.
- `USE_QT5` : privilégie Qt 5 au lieu de Qt 6. Désactivée par défaut.

Exemple :

```sh
cmake -S vmpk-x.y.z -B vmpk-x.y.z-build -DENABLE_DBUS=OFF
```

## NOTES POUR LINUX

Une page de manuel prête à être installée est incluse dans l’archive source. Pour la générer vous-même, installez :

- le programme `xsltproc` ;
- les feuilles de style DocBook XSLT.

Sous Debian, les paquets sont `xsltproc`, `docbook-xsl` et `docbook-xml`. Sous openSUSE, utilisez `libxslt`, `docbook_4` et `docbook-xsl-stylesheets`.

## NOTES POUR WINDOWS

Téléchargez l’archive source au format .bz2 ou .gz et décompressez-la avec un outil compatible, par exemple [7-Zip](https://www.7-zip.org/).

Pour configurer la compilation, utilisez QMake (Qt) ou CMake. Ajoutez au `PATH` les répertoires des exécutables Qt, MinGW et CMake. `cmake-gui` est l’interface graphique de CMake.

Pour produire du son, VMPK nécessite un synthétiseur MIDI. Windows fournit le « Microsoft GS Wavetable SW Synth ». Pour de meilleures performances et une meilleure qualité, vous pouvez utiliser FluidSynth ou [Virtual MIDI Synth](https://coolsoft.altervista.org/en/virtualmidisynth).

Un synthétiseur MIDI matériel externe est également une option.

Pour connecter VMPK à d’autres logiciels MIDI, vous aurez besoin d’un câble MIDI virtuel, par exemple MIDI Yoke, LoopBe1 ou [LoopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html).

- http://www.midiox.com/myoke.htm
- https://www.nerds.de/en/loopbe1.html
- https://www.tobias-erichsen.de/software/loopmidi.html

## NOTES POUR macOS

Le système de compilation peut créer une application macOS. Vous avez besoin des outils et frameworks de développement Apple ainsi que du SDK Qt. VMPK >= 0.6 nécessite le framework Cocoa et la version Cocoa de Qt.

Avec QMake :

```sh
qmake vmpk.pro -spec macx-g++
make
macdeployqt build/vmpk.app
```

Avec CMake et Makefiles :

```sh
cmake -G "Unix Makefiles" -S vmpk-x.y.z -B vmpk-x.y.z-build
make
```

Pour générer un projet Xcode :

```sh
qmake vmpk.pro -spec macx-xcode
# ou :
cmake -G Xcode -S vmpk-x.y.z -B vmpk-x.y.z-build
```

Vous pouvez utiliser le synthétiseur MIDI intégré à macOS, avec ou sans un logiciel externe comme [SimpleSynth](https://notahat.com/simplesynth/). Le même auteur propose également [MIDI Patchbay](https://notahat.com/midi_patchbay/).

## REMERCIEMENTS

VMPK utilise également des contributions issues de projets libres :

- **Qtractor**, par Rui Nuno Capela : https://qtractor.sourceforge.io  
  Classes de données de définition des instruments et éditeur de raccourcis.
- **Icône et logo**, par Theresa Knott : https://openclipart.org/detail/366/piano-by-theresaknott

Consultez le fichier [AUTHORS](AUTHORS) pour la liste complète des contributions.

Merci à toutes et à tous !
