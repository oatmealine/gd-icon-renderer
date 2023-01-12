require "vips"
require "./lib/plist.cr"

def parse_vec(str : String)
  a = str[1..-2].split(",").map { |v| Int32.new(v) }
  {a[0], a[1]}
end

module IconRenderer
  extend self

  VERSION = "0.1.0"

  icon_img = IconRenderer::Renderer.render_icon("ship_44", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0])
  alpha = icon_img.extract_band(3)
  left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
  icon_img = icon_img.crop(left, top, width, height)
  icon_img.write_to_file("test.png")
end

include IconRenderer

module IconRenderer::Assets
  extend self

  # Loads a .plist file and parses it. Made as a quick shorthand.
  def load_plist(path : String)
    File.open(path) { |file|
      PList.parse(file)
    }.not_nil!
  end

  GAME_SHEET_02 = {load_plist("GJ_GameSheet02-uhd.plist"), "GJ_GameSheet02-uhd"}
  GAME_SHEET_GLOW = {load_plist("GJ_GameSheetGlow-uhd.plist"), "GJ_GameSheetGlow-uhd"}

  # Load a given asset. `path` acts as the name, while `assets` is a tuple of the parsed .plist file and its name; see `load_plist`.
  def load(path : String, assets : Tuple(PList::Value, String))
    if File.exists?("#{assets[1]}/#{path}")
      {
        Vips::Image.new_from_file("#{assets[1]}/#{path}"),
        (assets[0])["frames"].as(Hash(String, PList::Value))["#{path}"].as(Hash(String, PList::Value))
      }
    else
      nil
    end
  end
end

# The main renderer module; familiarity with [CrystalVips](https://naqvis.github.io/crystal-vips/index.html) is highly recommended.
module IconRenderer::Renderer
  extend self

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

  # The main entrypoint for icon rendering; this should be all you need to render out an icon.
  #
  # Example:
  # ```
  # # Render out the icon
  # icon_img = IconRenderer::Renderer.render_icon("ship_44", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0])
  # # Trim it out
  # alpha = icon_img.extract_band(3)
  # left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
  # icon_img = icon_img.crop(left, top, width, height)
  # # Write it to a file
  # icon_img.write_to_file("icon_rendered.png")
  # ```
  def render_icon(filename : String, col1 : Array(Float64), col2 : Array(Float64))
    layers = [
      Assets.load("#{filename}_glow_001.png", Assets::GAME_SHEET_GLOW),
      Assets.load("#{filename}_2_001.png", Assets::GAME_SHEET_02),
      Assets.load("#{filename}_3_001.png", Assets::GAME_SHEET_02),
      Assets.load("#{filename}_001.png", Assets::GAME_SHEET_02),
      Assets.load("#{filename}_extra_001.png", Assets::GAME_SHEET_02),
    ]

    colors = [col2, col2, nil, col1, nil]

    i = -1
    render_layered(
      layers.select { |v| v != nil }.map { |t| t.not_nil![0] },
      layers.select { |v| v != nil }.map { |t| parse_vec(t.not_nil![1].not_nil!["spriteSourceSize"].as(String)) },
      colors.select { |v| layers[(i += 1)]? }
    )
  end
end
