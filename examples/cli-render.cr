# example usage:
# crystal run examples/cli-render.cr -- player_ball_35 --color1 000000 --color2 ff7d7d --glow

require "option_parser"
require "vips"
require "../src/gd-icon-renderer.cr"

include IconRenderer

GAME_SHEET_02 = Assets.load_spritesheet("data/GJ_GameSheet02-uhd.plist")
GAME_SHEET_GLOW = Assets.load_spritesheet("data/GJ_GameSheetGlow-uhd.plist")

icon_name = nil
output = "icon_rendered.png"
color1 = "7dff00"
color2 = "00ffff"
glow = false

OptionParser.parse do |parser|
  parser.banner = "Usage: cli-render [arguments]"
  parser.on("-o NAME", "--output=NAME", "Specify the output file") { |name| output = name }
  parser.on("--color1=COLOR", "First color") { |col| color1 = col }
  parser.on("--color2=COLOR", "Second color") { |col| color2 = col }
  parser.on("--glow", "Enable glow") { glow = true }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
  parser.unknown_args do |opt|
    icon_name = opt[0]?
  end
end

if !icon_name
  STDERR.puts "ERROR: no icon name specified!"
  exit(1)
end

def hex_to_rgb(hex : String)
  components = hex.scan(/.{2}/)
  red, green, blue = components.map(&.[0].to_i(16))
  return [red / 255, green / 255, blue / 255, 1.0]
end

start = Time.monotonic

icon_img = Renderer.render_icon(icon_name.not_nil!, hex_to_rgb(color1), hex_to_rgb(color2), glow, GAME_SHEET_02, GAME_SHEET_GLOW)
alpha = icon_img.extract_band(3)
left, top, width, height = alpha.find_trim(threshold: 1, background: [0])
icon_img = icon_img.crop(left, top, width, height)

puts "Rendered in #{(Time.monotonic - start).total_seconds.humanize(precision: 2, significant: false)}s"
puts "Writing to #{output}"
icon_img.write_to_file(output)
