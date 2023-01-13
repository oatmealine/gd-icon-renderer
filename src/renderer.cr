# The main renderer module; familiarity with [CrystalVips](https://naqvis.github.io/crystal-vips/index.html) is highly recommended.
module IconRenderer::Renderer
  extend self

  # Mainly for internal use; given an array of images, their sizes and colors, tints and composits them over each other.
  def render_layered(images : Array(Vips::Image), sizes : Array(Tuple(Int32, Int32)), colors : Array(Array(Float64)?))
    bounding_box = sizes.reduce { |p1, p2| {Math.max(p1[0], p2[0]), Math.max(p1[1], p2[1])} }
    (colors[0]? ? images[0] * colors[0] : images[0])
      .embed(
        x: Int32.new(bounding_box[0]/2 - sizes[0][0]/2),
        y: Int32.new(bounding_box[1]/2 - sizes[0][1]/2),
        width: bounding_box[0], height: bounding_box[1]
      )
      .composite(
        images[1..].map_with_index { |img, i| colors[i+1]? ? img * colors[i+1] : img },
        [Vips::Enums::BlendMode::Over],
        x: sizes[1..].map { |v| bounding_box[0]/2 - v[0]/2 },
        y: sizes[1..].map { |v| bounding_box[1]/2 - v[1]/2 }
      )
  end

  private def is_black(c : Array(Float64))
    c[0] == 0.0 && c[1] == 0.0 && c[2] == 0.0
  end

  # The main entrypoint for icon rendering; this should be all you need to render out an icon.
  #
  # Example:
  # ```
  # # Load assets
  # GAME_SHEET_02 = IconRenderer::Assets.load_spritesheet("data/GJ_GameSheet02-uhd.plist")
  # GAME_SHEET_GLOW = IconRenderer::Assets.load_spritesheet("data/GJ_GameSheetGlow-uhd.plist")
  # # Render out the icon
  # icon_img = IconRenderer::Renderer.render_icon("ship_44", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], true, GAME_SHEET_02, GAME_SHEET_GLOW)
  # # Trim it out
  # alpha = icon_img.extract_band(3)
  # left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
  # icon_img = icon_img.crop(left, top, width, height)
  # # Write it to a file
  # icon_img.write_to_file("icon_rendered.png")
  # ```
  def render_icon(basename : String, col1 : Array(Float64), col2 : Array(Float64), glow : Bool, game_sheet_02 : Assets::LoadedSpritesheet, game_sheet_glow : Assets::LoadedSpritesheet)
    glow_col = is_black(col2) ? (is_black(col1) ? [1.0, 1.0, 1.0, 1.0] : col1) : col2

    layers = [
      (glow || (is_black(col1) && is_black(col2))) ? Assets.get_sprite(game_sheet_glow, "#{basename}_glow_001.png") : nil,
      Assets.get_sprite(game_sheet_02, "#{basename}_2_001.png"),
      Assets.get_sprite(game_sheet_02, "#{basename}_3_001.png"),
      Assets.get_sprite(game_sheet_02, "#{basename}_001.png"),
      Assets.get_sprite(game_sheet_02, "#{basename}_extra_001.png"),
    ]

    colors = [glow_col, col2, nil, col1, nil]

    i = -1
    render_layered(
      layers.select { |v| v != nil }.map { |t| t.not_nil![0] },
      layers.select { |v| v != nil }.map { |t| t.not_nil![1].source_size },
      colors.select { |v| layers[(i += 1)]? }
    )
  end
end
