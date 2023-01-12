# gd-icon-renderer

[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://oatmealine.github.io/gd-icon-renderer/)

A (WIP) Crystal Geometry Dash icon renderer library, utilizing [libvips](https://www.libvips.org/)

## Why?

Server-side rendering of icons. This functionality doesn't need to be restricted to an HTTP server, so I figured I could just move it into a library.

## How to use

The library is in its infancy stages; you'll be offered very little support in getting this to work in an actual application. Currently, you'll have to plug an [extracted spritesheet](https://gdcolon.com/gdsplitter/) of `GJ_GameSheet02-uhd` and `GJ_GameSheetGlow-uhd` along with their `plist` files in `data/`.

After that's done, run `shards install` and `shards build`; you'll need `libvips-devel` installed for the build step and `libvips` itself installed during runtime. Then run `bin/gd-icon-renderer` or `shards run` to do a quick test of whatever's being tested right now.