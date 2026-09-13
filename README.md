## Requirements

To build this project you need the following software installed:

- [CMake](https://repology.org/project/cmake/versions) (>= 3.5)
- [GNU Make](https://repology.org/project/make/versions) (or another CMake-supported build tool)
- [ImageMagick](https://repology.org/project/imagemagick/versions) (>= 7, the `magick` CLI is used to render the SVGs to PNGs and to generate the preview thumbnail collage for each theme)
- [xcursorgen](https://repology.org/project/xcursorgen/versions) (compiles the PNG frames into Xcursor files)
- [tar](https://repology.org/project/tar/versions) (used to package the generated themes into .tar.bz2 archives)

## How to build

How to generate all the pngs and the SVGs and the cursor files:

```sh
rm -rf build \
  && mkdir build \
  && cd build \
  && cmake ../src

# to build everything (GNU Make generator)
make -j2

# to build everything (generator-agnostic)
cmake --build . -j2

# to only build specific color (GNU Make generator)
make -j2 [theme-<color>|package-<color>]

# to only build specific color (generator-agnostic)
cmake --build . --target [theme-<color>|package-<color>] -j2
```

Just note that here we use `-j2` because larger values caused some weird erros.

Where <color> is the color you want generated if you want just one of them.

The build system is still young, with rough edges (e.g. doesn't check if convert is found). Hopefully it will work, but there may still be problems.

All of what you see here is to be considered a work in progress, and therefore must be considered as unreleased.


Running `make` (or `cmake --build .`) produces a `.tar.bz2` archive for each requested theme under `build/packages/`. Each archive contains both the theme directory (`oxy-<color>/...`) and a pointer theme file at `default/index.theme` that inherits from that theme. Running `make theme-<color>` (or `cmake --build . --target theme-<color>`) instead just generates the theme's files (PNGs, SVGs, cursors) directly under `build/oxy-<color>/`, without packaging them into an archive.

Example code:

```sh
cmake --build . --target package-wonton -j2
```

Package layout (inside `oxy-<color>.tar.bz2`):

```text
oxy-<color>/
├── cursors/
│   ├── left_ptr
│   ├── hand2
│   ├── ...
│   └── wait
└── index.theme
default/
└── index.theme
```

Building also automatically generates a preview thumbnail for each theme, a collage of a handful of representative cursors rendered in that theme's colors, written to `build/thumbnails/oxy-<color>.png`. These thumbnails are generated for preview purposes only and are not included in the `.tar.bz2` packages.

## How to install the cursors

Once a theme has been built, install it by extracting its package into your icons directory, for example, to install it only for your own user:

```sh
mkdir -p ~/.icons
tar xjf build/packages/oxy-<color>.tar.bz2 -C ~/.icons
```

Or system-wide, for all users (requires root):

```sh
sudo tar xjf build/packages/oxy-<color>.tar.bz2 -C /usr/share/icons
```

After installing, the theme can be selected like any other cursor theme, e.g. in KDE Plasma via System Settings -> Appearance -> Cursors. Xcursor themes work the same way under both X11 and Wayland sessions, so no extra steps are needed for Wayland compositors such as KWin.

Note: because each package includes `default/index.theme`, installing a second package into the same icons directory will overwrite `default/index.theme` and therefore change which theme the `default` pointer inherits from.

Information on the graphics: Riccardo "ruphy" Iaconelli <riccardo@kde.org> 
Information on the build system: Matthew Woehlke <mw_triad@users.sourceforge.net> and Diego 'Flameeyes' Pettenò.
Preferred place to get help: #oxygen on irc.freenode.net (http://freenode.net/)
