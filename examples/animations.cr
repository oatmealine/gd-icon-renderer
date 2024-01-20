require "../src/gd-icon-renderer.cr"

# Load assets
SHEET = IconRenderer::Assets.load_spritesheet("data/icons/spider_01-uhd.plist")
ANIMATIONS = IconRenderer::Assets.load_animations("data/Spider_AnimDesc.plist")
# Render out the icon
icon_img = IconRenderer::Renderer.render_spicy("spider_01", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], true, SHEET, ANIMATIONS)
# Trim it out
alpha = icon_img.extract_band(3)
left, top, width, height = alpha.find_trim(threshold: 1, background: [0])
icon_img = icon_img.crop(left, top, width, height)
# Write it to a file
icon_img.write_to_file("icon_rendered.png")
