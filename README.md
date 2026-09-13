## Requirements

To build this project you need the following software installed:

- [CMake](https://repology.org/project/cmake/versions) (>= 3.5)
- [GNU Make](https://repology.org/project/make/versions) (or another CMake-supported build tool)
- [Inkscape](https://repology.org/project/inkscape/versions) (used to render the SVGs to PNGs)
- [xcursorgen](https://repology.org/project/xcursorgen/versions) (compiles the PNG frames into Xcursor files)
- [tar](https://repology.org/project/tar/versions) (used to package the generated themes into .tar.bz2 archives)

## How to build

How to generate all the pngs and the SVGs and the cursor files:

```sh
mkdir build
cd build
cmake ../src
make -j$(nproc --ignore 1) [theme-<color>|package-<color>]
```

Where <color> is the color you want generated if you want just one of them.

The build system is still young, with rough edges (e.g. doesn't check if inkscape is found). Hopefully it will work,
but there may still be problems.

All of what you see here is to be considered a work in progress, and therefore must be considered as unreleased.

Running `make` (or `make package-<color>`) produces a `.tar.bz2` archive for
each requested theme under `build/packages/`. Running `make theme-<color>`
instead just generates the theme's files (PNGs, SVGs, cursors) directly
under `build/oxy-<color>/`, without packaging them into an archive.

## How to install the cursors

Once a theme has been built, install it by extracting its package into your
icons directory, for example, to install it only for your own user:

```sh
mkdir -p ~/.icons
tar xjf build/packages/oxy-<color>.tar.bz2 -C ~/.icons
```

Or system-wide, for all users (requires root):

```sh
sudo tar xjf build/packages/oxy-<color>.tar.bz2 -C /usr/share/icons
```

After installing, the theme can be selected like any other cursor theme,
e.g. in KDE Plasma via System Settings -> Appearance -> Cursors. Xcursor
themes work the same way under both X11 and Wayland sessions, so no extra
steps are needed for Wayland compositors such as KWin.

Information on the graphics: Riccardo "ruphy" Iaconelli <riccardo@kde.org>
Information on the build system: Matthew Woehlke <mw_triad@users.sourceforge.net> and Diego 'Flameeyes' Pettenò.
Preferred place to get help: #oxygen on irc.freenode.net (http://freenode.net/)
