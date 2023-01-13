require "option_parser"
require "vips"
require "../src/gd-icon-renderer.cr"

filepath = nil
output = "sprite.png"

OptionParser.parse do |parser|
  parser.banner = "Usage: sprite-extract [arguments]"
  parser.on("-o NAME", "--output=NAME", "Specify the output file") { |name| output = name }
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
    filepath = opt[0]?
  end
end

if !filepath
  STDERR.puts "ERROR: no plist file specified!"
  exit(1)
end

path = Path.new(filepath.not_nil!)

spritesheet = IconRenderer::Assets.load_spritesheet(path)

puts "using plist: #{filepath}"

sprites = spritesheet.sheet.sprites.keys

sprites_dir = path.parent / path.stem
Dir.mkdir_p(sprites_dir)

start = Time.monotonic

sprites.each() do |sprite_name|
  puts "extracting: #{sprite_name}"
  sprite = IconRenderer::Assets.get_sprite(spritesheet, sprite_name)
  sprite.not_nil![0].write_to_file((sprites_dir / sprite_name).to_s)
end

puts "done in #{(Time.monotonic - start).total_seconds.humanize(precision: 2, significant: false)}s"
