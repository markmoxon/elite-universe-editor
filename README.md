# Elite Universe Editor

[BBC Micro cassette Elite](https://github.com/markmoxon/elite-source-code-bbc-micro-cassette) | [BBC Micro disc Elite](https://github.com/markmoxon/elite-source-code-bbc-micro-disc) | [Acorn Electron Elite](https://github.com/markmoxon/elite-source-code-acorn-electron) | [6502 Second Processor Elite](https://github.com/markmoxon/elite-source-code-6502-second-processor) | [Commodore 64 Elite](https://github.com/markmoxon/elite-source-code-commodore-64) | [Apple II Elite](https://github.com/markmoxon/elite-source-code-apple-ii) | [BBC Master Elite](https://github.com/markmoxon/elite-source-code-bbc-master) | [NES Elite](https://github.com/markmoxon/elite-source-code-nes) | [Elite-A](https://github.com/markmoxon/elite-a-source-code-bbc-micro) | [Teletext Elite](https://github.com/markmoxon/teletext-elite) | **Elite Universe Editor** | [Elite Compendium (BBC Master)](https://github.com/markmoxon/elite-compendium-bbc-master) | [Elite Compendium (BBC Micro)](https://github.com/markmoxon/elite-compendium-bbc-micro) | [Elite over Econet](https://github.com/markmoxon/elite-over-econet) | [Flicker-free Commodore 64 Elite](https://github.com/markmoxon/c64-elite-flicker-free) | [BBC Micro Aviator](https://github.com/markmoxon/aviator-source-code-bbc-micro) | [BBC Micro Revs](https://github.com/markmoxon/revs-source-code-bbc-micro) | [Archimedes Lander](https://github.com/markmoxon/lander-source-code-acorn-archimedes)

![The Elite Universe Editor on the BBC Micro](https://elite.bbcelite.com/images/github/elite-universe-editor-home-screen.png)

![The Elite Universe Editor on the Commodore 64](https://elite.bbcelite.com/images/github/elite-universe-editor-home-screen-c64.png)

This repository collects together the source code for the Elite Universe Editor on the BBC Master, the BBC Micro with a 6502 Second Processor and the Commodore 64.

The Elite Universe Editor allows you to create your own universes in classic BBC Micro and Commodore 64 Elite. For more information, see the [bbcelite.com website](https://elite.bbcelite.com/hacks/elite_universe_editor.html).

This repository builds the Universe Editor by pulling in the source code from various submodules:

* [Elite Universe Editor Library](https://github.com/markmoxon/elite-universe-editor-library)
* [BBC Master Elite Universe Editor](https://github.com/markmoxon/elite-universe-editor-bbc-master)
* [6502 Second Processor Elite Universe Editor](https://github.com/markmoxon/elite-universe-editor-6502-second-processor)
* [Commodore 64 Elite Universe Editor](https://github.com/markmoxon/elite-universe-editor-commodore-64)

![Creating the screenshot from the original BBC Micro box in the Elite Universe Editor](https://elite.bbcelite.com/images/github/elite-universe-editor-boxart-2.png)

![Creating the screenshot from the original Commodore 64 box in the Elite Universe Editor](https://elite.bbcelite.com/images/github/elite-universe-editor-boxart-c.png)

## Contents

* [Acknowledgements](#acknowledgements)

  * [A note on licences, copyright etc.](#user-content-a-note-on-licences-copyright-etc)

* [Browsing the source in an IDE](#browsing-the-source-in-an-ide)

* [Folder structure](#folder-structure)

* [Building the Elite Universe Editor from the source](#building-the-elite-universe-editor-from-the-source)

  * [Requirements](#requirements)
  * [Windows](#windows)
  * [Mac and Linux](#mac-and-linux)

* [The Commodore 64 patching process](#the-commodore-64-patching-process)

## Acknowledgements

6502 Second Processor Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1985.

The 6502 Second Processor code on this site is identical to the source discs released on [Ian Bell's personal website](http://www.elitehomepage.org/) (it's just been reformatted to be more readable).

BBC Master Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1986.

The BBC Master code on this site has been reconstructed from a disassembly of the version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

Commodore 64 Elite was written by Ian Bell and David Braben and published by Firebird, and is copyright &copy; D. Braben and I. Bell 1985.

The code in the Commodore 64 flicker-free patch was reconstructed from a disassembly of the BBC Master version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

The Commodore 64 game disks in this repository are very similar to those released on [Ian Bell's personal website](http://www.elitehomepage.org/), but to ensure accuracy to the released versions, I've used disk images from the [Commodore 64 Preservation Project](https://archive.org/details/C64_Preservation_Project_10th_Anniversary_Collection) (it turns out that the disk images on Ian Bell's site differ slightly from the official versions). The Commodore Plus/4 version is based on the disk image from Ian Bell's site.

The commentary and Universe Editor code is copyright &copy; Mark Moxon. Any misunderstandings or mistakes in the documentation are entirely my fault.

Huge thanks are due to the original authors for not only creating such an important piece of my childhood, but also for releasing the source code for us to play with; to Paul Brink for his annotated disassembly; and to Kieran Connell for his [BeebAsm version](https://github.com/kieranhj/elite-beebasm), which I forked as the original basis for this project. You can find more information about this project in the [accompanying website's project page](https://elite.bbcelite.com/about_site/about_this_project.html).

Also, a big thumbs up to Kroc Camen for his epic [Elite Harmless](https://github.com/Kroc/elite-harmless) project, which is a really useful reference for anyone exploring the C64 binaries. Finally, thanks to the gurus in this [Lemon64 forum thread](https://www.lemon64.com/forum/viewtopic.php?t=67762&start=90) for their sage advice.

The following archives from Ian Bell's personal website form the basis for this project:

* [6502 Second Processor sources as a disc image](http://www.elitehomepage.org/archive/a/a5022201.zip)

* [BBC Elite, Master version](http://www.elitehomepage.org/archive/a/b8020001.zip)

### A note on licences, copyright etc.

This repository is _not_ provided with a licence, and there is intentionally no `LICENSE` file provided.

According to [GitHub's licensing documentation](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/licensing-a-repository), this means that "the default copyright laws apply, meaning that you retain all rights to your source code and no one may reproduce, distribute, or create derivative works from your work".

The reason for this is that the Universe Editor is intertwined with the original Elite source code, and the original source code is copyright. The whole site is therefore covered by default copyright law, to ensure that this copyright is respected.

Under GitHub's rules, you have the right to read and fork this repository... but that's it. No other use is permitted, I'm afraid.

My hope is that the educational and non-profit intentions of this repository will enable it to stay hosted and available, but the original copyright holders do have the right to ask for it to be taken down, in which case I will comply without hesitation. I do hope, though, that along with the various other disassemblies and commentaries of this source, it will remain viable.

## Browsing the source in an IDE

If you want to browse the source in an IDE, you might find the following useful.

* The Universe Editor code is in the [main-sources folder in the library submodule](https://github.com/markmoxon/elite-universe-editor-library/main-sources). It is split up into multiple files to enable it to be squeezed into the different versions of Elite (which have different memory maps and different amounts of free space).

* It's probably worth skimming through the [notes on terminology and notations](https://elite.bbcelite.com/about_site/terminology_used_in_this_commentary.html) on the accompanying website, as this explains a number of terms used in the commentary, without which it might be a bit tricky to follow at times (in particular, you should understand the terminology I use for multi-byte numbers).

* The source code for the main Elite game (which the Universe Editor modifies) is in the [elite-universe-editor-6502-second-processor](https://github.com/markmoxon/elite-universe-editor-6502-second-processor) and [elite-universe-editor-bbc-master](https://github.com/markmoxon/elite-universe-editor-bbc-master) submodules. The annotated source files in these folders contain both the original Acornsoft code and all of the modifications made to hook the Universe Editor into the game, so you can look through the source to see exactly what's changed in order to add the Universe Editor. Any code that I've removed from the original version is commented out in the source files, so when they are assembled they produce the Universe Editor binaries, while still containing details of all the modifications. You can find all the diffs by searching the sources for `Mod:`.

* The Commodore 64 version doesn't contain source for the original game, but instead patches the original game binaries to add the Universe Editor. This process is described in [the Commodore 64 patching process](#the-commodore-64-patching-process) below. The Universe Editor uses the same source files on all platforms, but there are some extra routines required by the Commodore 64 version, which can be found in the [src folder in the c64 submodule](https://github.com/markmoxon/elite-universe-editor-commodore-64/src) folder.

* There are loads of routines and variables in Elite - literally hundreds. You can find them in the source files by searching for the following: `Type: Subroutine`, `Type: Variable`, `Type: Workspace` and `Type: Macro`.

* If you know the name of a routine, you can find it by searching for `Name: <name>`, as in `Name: SCAN` (for the 3D scanner routine) or `Name: LL9` (for the ship-drawing routine).

* The source code is designed to be read at an 80-column width and with a monospaced font, just like in the good old days.

I hope you enjoy exploring the inner workings of the Elite Universe Editor as much as I've enjoyed writing it.

## Folder structure

There are three main folders and four submodules in this repository.

* [1-source-files](source-files) contains the source files for creating the BBC disc images and README files.

* [2-assembled-output](2-assembled-output) contains the output binaries from the build process for the Elite Universe Editor.

* [3-compiled-game-discs](3-compiled-game-discs) contains the disk images produced by the build process. These disks contain the Universe Editor.

* [elite-universe-editor-library](https://github.com/markmoxon/elite-universe-editor-library) contains the shared source files for the Universe Editor. The same source is used for all versions.

* [elite-universe-editor-6502-second-processor](https://github.com/markmoxon/elite-universe-editor-6502-second-processor) contains the source code for 6502 Second Processor Elite, modified to hook in the Universe Editor.

* [elite-universe-editor-bbc-master](https://github.com/markmoxon/elite-universe-editor-bbc-master) contains the source code for BBC Master Elite, modified to hook in the Universe Editor.

* [elite-universe-editor-commodore-64](https://github.com/markmoxon/elite-universe-editor-commodore-64) contains the original disk images for Commodore 64 Elite, which we extract and modify to hook in the Universe Editor.

The 6502sp and master submodules are downstream of the repositories containing the fully documented source code for Elite on the [6502 Second Processor](https://github.com/markmoxon/elite-source-code-6502-second-processor) and [BBC Master](https://github.com/markmoxon/elite-source-code-bbc-master).

The c64 submodule uses a patching process that's described in [the Commodore 64 patching process](#the-commodore-64-patching-process) below.

## Building the Elite Universe Editor from the source

### Requirements

You will need the following to build the Elite Universe Editor from the source:

* BeebAsm, which can be downloaded from the [BeebAsm repository](https://github.com/stardot/beebasm). Mac and Linux users will have to build their own executable with `make code`, while Windows users can just download the `beebasm.exe` file.

* Python. Both versions 2.7 and 3.x should work.

* Mac and Linux users may need to install `make` if it isn't already present (for Windows users, `make.exe` is included in this repository).

* For the Commodore 64 build, you will also need c1541 from the VICE emulator, which can be downloaded from the [VICE site](https://vice-emu.sourceforge.io).

Builds are supported for both Windows and Mac/Linux systems, but please note that Windows only builds the BBC version. To build the Commodore 64 version as well, you will need to be on a Mac or Linux box. The process may work on the Windows Subsystem for Linux, but I haven't tested it.

In all cases the build process is defined in the `Makefile` provided. Let's look at how to build the Elite Universe Editor from the source.

### Windows

For Windows users, there is a batch file called `make.bat` that runs the build. Before this will work, you should edit the batch file and change the values of the `BEEBASM` and `PYTHON` variables to point to the locations of your `beebasm.exe` and `python.exe` executables. You also need to change directory to the repository folder (i.e. the same folder as `make.bat`).

All being well, doing the following:

```
make.bat
```

will produce a file called `elite-universe-editor-bbc.ssd` in the [`3-compiled-game-discs`](3-compiled-game-discs) folder that contains the BBC version of the Universe Editor, which you can then load into an emulator, or into a real BBC Micro using a device like a Gotek.

Note that the Windows build will terminate with an error after the BBC disc image is created. This is because the Commodore 64 build only works on Mac and Linux.

### Mac and Linux

The build process uses a standard GNU `Makefile`, so you just need to install `make` if your system doesn't already have it. If BeebAsm or Python are not on your path, then you can either fix this, or you can edit the `Makefile` and change the `BEEBASM` and `PYTHON` variables in the first two lines to point to their locations. You also need to change directory to the repository folder (i.e. the same folder as `Makefile`).

All being well, doing the following:

```
make
```

will produce three files in the [`3-compiled-game-discs`](3-compiled-game-discs) folder called `elite-universe-editor-bbc.ssd`, `elite-universe-editor-c64-ntsc.ssd` and `elite-universe-editor-c64-pal.ssd`. These contain the BBC version of the Universe Editor, and the NTSC and PAL versions of the Commodore 64 Universe Editor. You can then load these into emulators or real machines.

## The Commodore 64 patching process

The BBC version of the Elite Universe Editor is built from scratch using the annotated source code for Elite with the Universe Editor added into the source (see the [6502 Second Processor](https://github.com/markmoxon/elite-source-code-6502-second-processor) and [BBC Master](https://github.com/markmoxon/elite-source-code-bbc-master) repositories for the original sources).

We don't have access to the source code for the Commodore 64 version of Elite, so in order to add the Universe Editor, we have to do the following:

* Extract the game binaries from the original Commodore 64 .g64 disk image (using c1541 from the VICE emulator)

* Assemble the additional code that's required for the Universe Editor (using BeebAsm as the source for the Universe Editor is shared between both platforms)

* Inject this new code into the game binaries and disable any copy protection code (using Python)

* Create a new disk image containing the modified game binaries (using c1541 once again)

To find out more about the above steps, take a look at the following files in the elite-universe-editor-commodore-64 submodule, which contain lots of comments about how the process works:

* The [`build.sh`](https://github.com/markmoxon/elite-universe-editor-commodore-64/build.sh) script controls the build. Read this for an overview of the patching process.

* The [`elite-universe-editor-c64.asm`](https://github.com/markmoxon/elite-universe-editor-commodore-64/src/elite-universe-editor-c64.asm) file is assembled by BeebAsm and produces a binary file called `editor.bin` that contains the bulk of the code that implements the Universe Editor. This binary file is then ready to be injected into the game binary to implement the Universe Editor patch.

* The [`elite-flicker-free.asm`](https://github.com/markmoxon/elite-universe-editor-commodore-64/src/elite-flicker-free.asm) file is assembled by BeebAsm and produces a number of binary files. These contain the bulk of the code that implements the flicker-free algorithm, which is also included in the Universe Editor. These code blocks are saved as binary files that are ready to be injected into the game binary to implement the patch.

* The [`elite-modify.py`](https://github.com/markmoxon/elite-universe-editor-commodore-64/src/elite-modify.py) script modifies the game binary and applies the Universe Editor and flicker-free patches. It does this by:

  * Loading the main binary into memory
  * Decrypting it
  * Patching it by injecting the output from BeebAsm and making a number of other modifications to the code
  * Encrypting the modified code
  * Saving out the encrypted and modified binary
  * Disabling any copy protection from the original disk

This approach is very similar to the patching process used to create the flicker-free version of Commodore 64 Elite. See the [c64-elite-flicker-free repository](https://github.com/markmoxon/c64-elite-flicker-free) for details.

---

Right on, Commanders!

_Mark Moxon_