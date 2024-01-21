# The main renderer module; familiarity with [CrystalVips](https://naqvis.github.io/crystal-vips/index.html) is highly recommended.
module IconRenderer::Renderer
  extend self

  private def transform(image : Vips::Image, color : Array(Float64)?, scale : Tuple(Float32, Float32)?, rotation : Float64?)
    if color
      image *= color
    end
    if scale
      image = image.resize(scale: scale[0].abs(), vscale: scale[1].abs())
      if scale[0] < 0
        image = image.fliphor
      end
      if scale[1] < 0
        image = image.flipver
      end
    end
    if rotation
      image = image.rotate(rotation)
    end
    image
  end

  # Mainly for internal use; given an array of images, their sizes and colors, tints and composits them over each other.
  def render_layered(images : Array(Vips::Image), positions : Array(Tuple(Float32, Float32)?), colors : Array(Array(Float64)?), scales : Array(Tuple(Float32, Float32)?), rotations : Array(Float64?))
    transformed = images.map_with_index { |img, i| transform(img, colors[i]?, scales[i]?, rotations[i]?) }
    sizes = transformed.map { |img| {img.width, img.height} }

    positions = images.map_with_index { |v, i| positions[i]? || {0, 0} }

    bounding_box = sizes
      .map_with_index { |s, i| {Int32.new(s[0] + positions[i][0].abs() * 2), Int32.new(s[1] + positions[i][1].abs() * 2)} }
      .reduce { |p1, p2| {Math.max(p1[0], p2[0]), Math.max(p1[1], p2[1])} }

    transformed[0]
      .embed(
        x: Int32.new(bounding_box[0]/2 + positions[0][0] - sizes[0][0]/2),
        y: Int32.new(bounding_box[1]/2 + positions[0][1] - sizes[0][1]/2),
        width: bounding_box[0], height: bounding_box[1]
      )
      .composite(
        transformed[1..],
        [Vips::Enums::BlendMode::Over],
        x: sizes[1..].map_with_index { |v, i| bounding_box[0]/2 + positions[i + 1][0] - v[0]/2 },
        y: sizes[1..].map_with_index { |v, i| bounding_box[1]/2 + positions[i + 1][1] - v[1]/2 }
      )
  end

  private def is_black(c : Array(Float64))
    c[0] == 0.0 && c[1] == 0.0 && c[2] == 0.0
  end

  # Renders out a non-robot/spider icon. You may be looking for `render_icon`.
  #
  # Example:
  # ```
  # SHEET = IconRenderer::Assets.load_spritesheet("data/icons/ship_44-uhd.plist")
  # icon_img = IconRenderer::Renderer.render_normal("ship_44", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], nil, true, SHEET)
  # ```
  def render_normal(basename : String, col1 : Array(Float64), col2 : Array(Float64), col3 : Array(Float64)?, glow : Bool, sheet : Assets::LoadedSpritesheet)
    glow_col = col3 || (is_black(col2) ? (is_black(col1) ? [1.0, 1.0, 1.0, 1.0] : col1) : col2)

    layers = [
      (glow || (is_black(col1) && is_black(col2))) ? Assets.get_sprite(sheet, "#{basename}_glow_001.png") : nil,
      Assets.get_sprite(sheet, "#{basename}_2_001.png"),
      Assets.get_sprite(sheet, "#{basename}_3_001.png"),
      Assets.get_sprite(sheet, "#{basename}_001.png"),
      Assets.get_sprite(sheet, "#{basename}_extra_001.png"),
    ]

    colors = [glow_col, col2, nil, col1, nil]

    i = -1
    render_layered(
      layers.select { |v| v != nil }.map { |t| t.not_nil![0] },
      layers.select { |v| v != nil }.map { |t| {t.not_nil![1].offset[0], t.not_nil![1].offset[1] * -1} },
      colors.select { |v| layers[(i += 1)]? },
      [nil], [nil]
    )
  end

  private def flip(scale, flipped)
    {scale[0] * (flipped[0] ? -1 : 1), scale[1] * (flipped[1] ? -1 : 1)}
  end

  # `render_normal`, except for robots and spiders. Additionally requires animations for both.
  #
  # Example:
  #
  # ```
  # SHEET = IconRenderer::Assets.load_spritesheet("data/icons/spider_01-uhd.plist")
  # SPIDER_ANIMATIONS = IconRenderer::Assets.load_animations("data/Spider_AnimDesc.plist")
  # icon_img = IconRenderer::Renderer.render_icon("spider_01", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], nil, true, SHEET, SPIDER_ANIMATIONS)
  # ```
  def render_spicy(basename : String, col1 : Array(Float64), col2 : Array(Float64), col3 : Array(Float64)?, glow : Bool, sheet : Assets::LoadedSpritesheet, animations : Assets::Animations)
    glow_col = col3 || (is_black(col2) ? (is_black(col1) ? [1.0, 1.0, 1.0, 1.0] : col1) : col2)
    glow = (glow || (is_black(col1) && is_black(col2)))

    # todo: change to argument
    anim = animations["Robot_idle_001.png"]? || animations["Spider_idle_001.png"]?

    if !anim
      raise "Animation not found"
    end

    layers = anim
      .sort_by { |a| a.z }
      .flat_map do |a|
        texture_name = a.texture.gsub(/(spider|robot)_01/, basename)
        names = [
          texture_name.sub("_001.png", "_2_001.png"),
          texture_name.sub("_001.png", "_3_001.png"),
          texture_name,
          texture_name.sub("_001.png", "_extra_001.png")
        ]
        colors = [col2, nil, col1, nil]

        if glow
          names << texture_name.sub("_001.png", "_glow_001.png")
          colors << glow_col
        end

        names.map_with_index { |v, i| {
          Assets.get_sprite(sheet, v),
          a.position,
          # bake the flipped status in the the scale
          flip(a.scale, a.flipped),
          a.rotation,
          glow && i == names.size-1,
          colors[i]
        } }
      end
      # put glow below everything
      .sort_by { |a| a[4] ? 0 : 1 }

    layers_r = layers.select { |v| v[0] != nil }

    render_layered(
      layers_r.map { |t| t[0].not_nil![0] },
      layers_r.map { |t| {t[0].not_nil![1].offset[0] + t[1][0] * 4, t[0].not_nil![1].offset[1] * -1 + t[1][1] * -4} },
      layers_r.map { |t| t[5] },
      layers_r.map { |t| t[2] },
      layers_r.map { |t| t[3] }
    )
  end

  # Given a `gamemode` and `icon`, makes an icon basename to be used in sheet lookups
  def get_basename(gamemode : Constants::GamemodeType, icon : Int32) : String
    "#{Constants::Gamemodes[gamemode].prefix}#{icon.to_s.rjust(2, '0')}"
  end

  # The main entrypoint for icon rendering; this should be all you need to render out an icon.
  #
  # Example:
  # ```
  # gamemode = IconRenderer::Constants::GamemodeType::Ball
  # icon_id = 35
  # # Load assets
  # ROBOT_ANIMATIONS = IconRenderer::Assets.load_animations("data/Robot_AnimDesc.plist")
  # SPIDER_ANIMATIONS = IconRenderer::Assets.load_animations("data/Spider_AnimDesc.plist")
  # basename = IconRenderer::Renderer.get_basename(gamemode, icon_id)
  # sheet = IconRenderer::Assets.load_spritesheet("data/icons/#{basename}-uhd.plist")
  # # Render out the icon
  # icon_img = IconRenderer::Renderer.render_icon(gamemode, icon_id, [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], true, sheet, ROBOT_ANIMATIONS, SPIDER_ANIMATIONS)
  # # Trim it out
  # alpha = icon_img.extract_band(3)
  # left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
  # icon_img = icon_img.crop(left, top, width, height)
  # # Write it to a file
  # icon_img.write_to_file("icon_rendered.png")
  # ```
  def render_icon(gamemode_type : Constants::GamemodeType, icon : Int32, col1 : Array(Float64), col2 : Array(Float64), col3 : Array(Float64)?, glow : Bool, sheet : Assets::LoadedSpritesheet, robot_animations : Assets::Animations, spider_animations : Assets::Animations)
    gamemode = Constants::Gamemodes[gamemode_type]
    basename = get_basename(gamemode_type, icon)
    if gamemode.spicy
      render_spicy(basename, col1, col2, col3, glow, sheet, gamemode_type.robot? ? robot_animations : spider_animations)
    else
      render_normal(basename, col1, col2, col3, glow, sheet)
    end
  end
end
