# Elite Universe Editor

![The Elite Universe Editor](https://www.bbcelite.com/images/github/elite-universe-editor-home-screen.png)

This repository contains source code for the Elite Universe Editor on the BBC Master and the BBC Micro with a 6502 Second Processor.

The Elite Universe Editor allows you to create your own universes in classic BBC Micro Elite. For more information, see the [bbcelite.com website](https://www.bbcelite.com/hacks/elite_universe_editor.html).

This repository contains the full source code for the Universe Editor, which you can build yourself on a modern computer. See below for more details on [browsing the source code](#browsing-the-source-in-an-ide) and [building the Elite Universe Editor from the source](#building-the-elite-universe-editor-from-the-source).

![Creating the screenshot from the original box in the Elite Universe Editor](https://www.bbcelite.com/images/github/elite-universe-editor-boxart-2.png)

## Contents

* [Acknowledgements](#acknowledgements)

  * [A note on licences, copyright etc.](#user-content-a-note-on-licences-copyright-etc)

* [Browsing the source in an IDE](#browsing-the-source-in-an-ide)

* [Folder structure](#folder-structure)

* [Building the Elite Universe Editor from the source](#building-the-elite-universe-editor-from-the-source)

  * [Requirements](#requirements)
  * [Windows](#windows)
  * [Mac and Linux](#mac-and-linux)

## Acknowledgements

6502 Second Processor Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1985.

The 6502 Second Processor code on this site is identical to the source discs released on [Ian Bell's personal website](http://www.elitehomepage.org/) (it's just been reformatted to be more readable).

BBC Master Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1986.

The BBC Master code on this site has been reconstructed from a disassembly of the version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

The commentary and Universe Editor code is copyright &copy; Mark Moxon. Any misunderstandings or mistakes in the documentation are entirely my fault.

Huge thanks are due to the original authors for not only creating such an important piece of my childhood, but also for releasing the source code for us to play with; to Paul Brink for his annotated disassembly; and to Kieran Connell for his [BeebAsm version](https://github.com/kieranhj/elite-beebasm), which I forked as the original basis for this project. You can find more information about this project in the [accompanying website's project page](https://www.bbcelite.com/about_site/about_this_project.html).

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

* The Universe Editor code is in the [universe-editor/main-sources](universe-editor/main-sources) folder. It is split up into multiple files to enable it to be squeezed into the different versions of Elite (which have different memory maps and different amounts of free space).

* It's probably worth skimming through the [notes on terminology and notations](https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html) on the accompanying website, as this explains a number of terms used in the commentary, without which it might be a bit tricky to follow at times (in particular, you should understand the terminology I use for multi-byte numbers).

* The source code for the main Elite game (which the Universe Editor modifies) is in the [6502sp-elite](6502sp-elite) and [master-elite](master-elite) folders. The annotated source files in these folders contain both the original Acornsoft code and all of the modifications made to hook the Universe Editor into the game, so you can look through the source to see exactly what's changed in order to add the Universe Editor. Any code that I've removed from the original version is commented out in the source files, so when they are assembled they produce the Universe Editor binaries, while still containing details of all the modifications. You can find all the diffs by searching the sources for `Mod:`.

* There are loads of routines and variables in Elite - literally hundreds. You can find them in the source files by searching for the following: `Type: Subroutine`, `Type: Variable`, `Type: Workspace` and `Type: Macro`.

* If you know the name of a routine, you can find it by searching for `Name: <name>`, as in `Name: SCAN` (for the 3D scanner routine) or `Name: LL9` (for the ship-drawing routine).

* The source code is designed to be read at an 80-column width and with a monospaced font, just like in the good old days.

I hope you enjoy exploring the inner workings of the Elite Universe Editor as much as I've enjoyed writing it.

## Folder structure

There are three main folders in this repository.

* [universe-editor](universe-editor) contains the source files for the Universe Editor.

* [6502sp-elite](6502sp-elite) contains the source code for 6502 Second Processor Elite, modified to hook in the Universe Editor.

* [master-elite](master-elite) contains the source code for BBC Master Elite, modified to hook in the Universe Editor.

The latter two are heavily based on the repositories containing the fully documented source code for Elite on the [6502 Second Processor](https://github.com/markmoxon/6502sp-elite-beebasm) and [BBC Master](https://github.com/markmoxon/master-elite-beebasm).

## Building the Elite Universe Editor from the source

### Requirements

You will need the following to build the Elite Universe Editor from the source:

* BeebAsm, which can be downloaded from the [BeebAsm repository](https://github.com/stardot/beebasm). Mac and Linux users will have to build their own executable with `make code`, while Windows users can just download the `beebasm.exe` file.

* Python. Both versions 2.7 and 3.x should work.

* Mac and Linux users may need to install `make` if it isn't already present (for Windows users, `make.exe` is included in this repository).

Builds are supported for both Windows and Mac/Linux systems. In all cases the build process is defined in the `Makefile` provided. Let's look at how to build the Elite Universe Editor from the source.

### Windows

For Windows users, there is a batch file called `make.bat` that runs the build. Before this will work, you should edit the batch file and change the values of the `BEEBASM` and `PYTHON` variables to point to the locations of your `beebasm.exe` and `python.exe` executables. You also need to change directory to the repository folder (i.e. the same folder as `make.bat`).

All being well, doing the following:

```
make.bat
```

will produce a file called `elite-universe-editor.ssd` in the project folder that contains the Universe Editor, which you can then load into an emulator, or into a real BBC Micro using a device like a Gotek.

### Mac and Linux

The build process uses a standard GNU `Makefile`, so you just need to install `make` if your system doesn't already have it. If BeebAsm or Python are not on your path, then you can either fix this, or you can edit the `Makefile` and change the `BEEBASM` and `PYTHON` variables in the first two lines to point to their locations. You also need to change directory to the repository folder (i.e. the same folder as `Makefile`).

All being well, doing the following:

```
make
```

will produce a file called `elite-universe-editor.ssd` in the project folder that contains the Universe Editor, which you can then load into an emulator, or into a real BBC Micro using a device like a Gotek.

---

Right on, Commanders!

_Mark Moxon_