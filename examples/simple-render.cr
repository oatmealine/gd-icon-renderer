require "../src/gd-icon-renderer.cr"

gamemode = IconRenderer::Constants::GamemodeType::Ball
icon_id = 35
# Load assets
ROBOT_ANIMATIONS = IconRenderer::Assets.load_animations("data/Robot_AnimDesc.plist")
SPIDER_ANIMATIONS = IconRenderer::Assets.load_animations("data/Spider_AnimDesc.plist")
basename = IconRenderer::Renderer.get_basename(gamemode, icon_id)
sheet = IconRenderer::Assets.load_spritesheet("data/icons/#{basename}-uhd.plist")
# Render out the icon
icon_img = IconRenderer::Renderer.render_icon(gamemode, icon_id, [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], nil, true, sheet, ROBOT_ANIMATIONS, SPIDER_ANIMATIONS)
# Trim it out
alpha = icon_img.extract_band(3)
left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
icon_img = icon_img.crop(left, top, width, height)
# Write it to a file
icon_img.write_to_file("icon_rendered.png")