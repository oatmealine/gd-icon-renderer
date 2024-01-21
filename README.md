# gd-icon-renderer

[![gd-icon-renderer CI](https://github.com/oatmealine/gd-icon-renderer/actions/workflows/ci.yml/badge.svg)](https://github.com/oatmealine/gd-icon-renderer/actions/workflows/ci.yml)
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

Currently, for most examples under `examples/`, you'll have to plug the `icons` folder of your GD install in `data/`. Otherwise, the process for rendering an icon is as follows:

1. Load spritesheets:

    ```crystal
    # Replace the filepaths here with whatever is relevant for your usecase
    sheet = IconRenderer::Assets.load_spritesheet("data/icons/ship_44-uhd.plist")
    ```

2. Render the icon out:

    ```crystal
    icon_img = IconRenderer::Renderer.render_icon("ship_44", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], nil, true, sheet)
    ```

    You'll now be given a [`Vips::Image`](https://naqvis.github.io/crystal-vips/Vips/Image.html).

3. (Optional) You might find it useful to now trim the whitespace out, as Geometry Dash icons usually have lots of surrounding blank space:

    ```crystal
    alpha = icon_img.extract_band(3)
    left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
    icon_img = icon_img.crop(left, top, width, height)
    ```

4. You'll most likely want to save the resulting image somewhere:
    ```crystal
    icon_img.write_to_file("icon_rendered.png")
    ```