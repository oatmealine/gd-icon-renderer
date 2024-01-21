require "../src/gd-icon-renderer.cr"

ITERS = 1_000

puts "running #{ITERS} iterations"

SHEET = IconRenderer::Assets.load_spritesheet("data/icons/spider_16-uhd.plist")
ANIMATIONS = IconRenderer::Assets.load_animations("data/Spider_AnimDesc.plist")

(1 .. ITERS).each do |i|
  puts i
  icon_img = IconRenderer::Renderer.render_spicy("spider_16", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], nil, true, SHEET, ANIMATIONS)
  icon_img.write_to_file("icon_rendered.png")
end