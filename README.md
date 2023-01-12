# gd-icon-renderer

[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://oatmealine.github.io/gd-icon-renderer/)

A (WIP) Crystal Geometry Dash icon renderer library, utilizing [libvips](https://www.libvips.org/)

## Why?

Server-side rendering of icons. This functionality doesn't need to be restricted to an HTTP server, so I figured I could just move it into a library.

## Pre-requisites

You'll need to install [libvips](https://www.libvips.org/install.html), alongside a `devel` package for building if available. **Be sure to leave this note in the README of the application you're making too.**

## Installation

1. Add the dependency to your `shard.yml`:

    ```yaml
    dependencies:
      gd-icon-renderer:
        github: oatmealine/gd-icon-renderer
    ```

2. Run `shards install`

## Usage

The library is in its infancy stages; you'll be offered very little support in getting this to work in an actual application.

Currently, for all examples under `examples/`, you'll have to plug an [extracted spritesheet](https://gdcolon.com/gdsplitter/) of `GJ_GameSheet02-uhd` and `GJ_GameSheetGlow-uhd` along with their `plist` files in `data/`.