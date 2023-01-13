require "../src/gd-icon-renderer.cr"

# Load assets
GAME_SHEET_02 = IconRenderer::Assets.load_spritesheet("data/GJ_GameSheet02-uhd.plist")
GAME_SHEET_GLOW = IconRenderer::Assets.load_spritesheet("data/GJ_GameSheetGlow-uhd.plist")
# Render out the icon
icon_img = IconRenderer::Renderer.render_icon("ship_44", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0], true, GAME_SHEET_02, GAME_SHEET_GLOW)
# Trim it out
alpha = icon_img.extract_band(3)
left, top, width, height = alpha.find_trim(threshold: 0, background: [0])
icon_img = icon_img.crop(left, top, width, height)
# Write it to a file
icon_img.write_to_file("icon_rendered.png")
