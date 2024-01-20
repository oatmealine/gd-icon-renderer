require "./gd-icon-renderer.cr"

include IconRenderer

ROBOT_ANIMATIONS = IconRenderer::Assets.load_animations("data/Robot_AnimDesc.plist")
SPIDER_ANIMATIONS = IconRenderer::Assets.load_animations("data/Spider_AnimDesc.plist")

icon_type = "cube"
icon_i = "0"
output = "icon_rendered.png"
color1 = "7dff00"
color2 = "00ffff"
glow = false

OptionParser.parse do |parser|
  parser.banner = "Usage: cli-render [arguments]"
  parser.on("--type=TYPE", "Set the icon type") { |type| icon_type = type }
  parser.on("-i INDEX", "--index=INDEX", "Set the icon index") { |i| icon_i = i }
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
end

if !icon_type
  STDERR.puts "ERROR: no icon type specified!"
  exit(1)
end
if !icon_i
  STDERR.puts "ERROR: no icon index specified!"
  exit(1)
end

def hex_to_rgb(hex : String)
  components = hex.scan(/.{2}/)
  red, green, blue = components.map(&.[0].to_i(16))
  return [red / 255, green / 255, blue / 255, 1.0]
end

start = Time.monotonic

gamemode = Constants::GamemodeType.parse icon_type
filename = Renderer.get_basename(gamemode, icon_i.to_i)

sheet = Assets.load_spritesheet("data/icons/#{filename}-uhd.plist")

icon_img = Renderer.render_icon(gamemode, icon_i.not_nil!.to_i, hex_to_rgb(color1), hex_to_rgb(color2), glow, sheet, ROBOT_ANIMATIONS, SPIDER_ANIMATIONS)
alpha = icon_img.extract_band(3)
left, top, width, height = alpha.find_trim(threshold: 1, background: [0])
icon_img = icon_img.crop(left, top, width, height)

puts "Writing to #{output}"
icon_img.write_to_file(output)
puts "Rendered in #{(Time.monotonic - start).total_seconds.humanize(precision: 2, significant: false)}s"