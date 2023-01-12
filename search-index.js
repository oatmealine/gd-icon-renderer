crystal_doc_search_index_callback({"repository_name":"gd-icon-renderer","body":"# gd-icon-renderer\n\nA (WIP) Crystal Geometry Dash icon renderer library, utilizing [libvips](https://www.libvips.org/)\n\n## Why?\n\nServer-side rendering of icons. This functionality doesn't need to be restricted to an HTTP server, so I figured I could just move it into a library.\n\n## How to use\n\nThe library is in its infancy stages; you'll be offered very little support in getting this to work in an actual application. Currently, you'll have to plug an [extracted spritesheet](https://gdcolon.com/gdsplitter/) of `GJ_GameSheet02-uhd` and `GJ_GameSheetGlow-uhd` along with their `plist` files in `data/`.\n\nAfter that's done, run `shards install` and `shards build`; you'll need `libvips-devel` installed for the build step and `libvips` itself installed during runtime. Then run `bin/gd-icon-renderer` or `shards run` to do a quick test of whatever's being tested right now.","program":{"html_id":"gd-icon-renderer/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"ancestors":[{"html_id":"gd-icon-renderer/IconRenderer","kind":"module","full_name":"IconRenderer","name":"IconRenderer"}],"locations":[],"repository_name":"gd-icon-renderer","program":true,"enum":false,"alias":false,"const":false,"included_modules":[{"html_id":"gd-icon-renderer/IconRenderer","kind":"module","full_name":"IconRenderer","name":"IconRenderer"}],"extended_modules":[{"html_id":"gd-icon-renderer/IconRenderer","kind":"module","full_name":"IconRenderer","name":"IconRenderer"}],"class_methods":[{"html_id":"parse_vec(str:String)-class-method","name":"parse_vec","abstract":false,"args":[{"name":"str","external_name":"str","restriction":"String"}],"args_string":"(str : String)","args_html":"(str : String)","location":{"filename":"src/gd-icon-renderer.cr","line_number":4,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L4"},"def":{"name":"parse_vec","args":[{"name":"str","external_name":"str","restriction":"String"}],"visibility":"Public","body":"a = (str[1..-2].split(\",\")).map do |v|\n  Int32.new(v)\nend\n{a[0], a[1]}\n"}}],"types":[{"html_id":"gd-icon-renderer/Hash","path":"Hash.html","kind":"class","full_name":"Hash(K, V)","name":"Hash","abstract":false,"superclass":{"html_id":"gd-icon-renderer/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"gd-icon-renderer/Iterable","kind":"module","full_name":"Iterable","name":"Iterable"},{"html_id":"gd-icon-renderer/Enumerable","kind":"module","full_name":"Enumerable","name":"Enumerable"},{"html_id":"gd-icon-renderer/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"gd-icon-renderer/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/lib/plist/generator.cr","line_number":55,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/lib/plist/generator.cr#L55"}],"repository_name":"gd-icon-renderer","program":false,"enum":false,"alias":false,"const":false,"included_modules":[{"html_id":"gd-icon-renderer/Enumerable","kind":"module","full_name":"Enumerable","name":"Enumerable"},{"html_id":"gd-icon-renderer/Iterable","kind":"module","full_name":"Iterable","name":"Iterable"}],"doc":"A `Hash` represents a collection of key-value mappings, similar to a dictionary.\n\nMain operations are storing a key-value mapping (`#[]=`) and\nquerying the value associated to a key (`#[]`). Key-value mappings can also be\ndeleted (`#delete`).\nKeys are unique within a hash. When adding a key-value mapping with a key that\nis already in use, the old value will be forgotten.\n\n```\n# Create a new Hash for mapping String to Int32\nhash = Hash(String, Int32).new\nhash[\"one\"] = 1\nhash[\"two\"] = 2\nhash[\"one\"] # => 1\n```\n\n[Hash literals](https://crystal-lang.org/reference/syntax_and_semantics/literals/hash.html)\ncan also be used to create a `Hash`:\n\n```\n{\"one\" => 1, \"two\" => 2}\n```\n\nImplementation is based on an open hash table.\nTwo objects refer to the same hash key when their hash value (`Object#hash`)\nis identical and both objects are equal to each other (`Object#==`).\n\nEnumeration follows the order that the corresponding keys were inserted.\n\nNOTE: When using mutable data types as keys, changing the value of a key after\nit was inserted into the `Hash` may lead to undefined behaviour. This can be\nrestored by re-indexing the hash with `#rehash`.","summary":"<p>A <code><a href=\"Hash.html\">Hash</a></code> represents a collection of key-value mappings, similar to a dictionary.</p>","instance_methods":[{"html_id":"to_plist-instance-method","name":"to_plist","abstract":false,"location":{"filename":"src/lib/plist/generator.cr","line_number":56,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/lib/plist/generator.cr#L56"},"def":{"name":"to_plist","visibility":"Public","body":"PList.to_plist(self)"}}]},{"html_id":"gd-icon-renderer/IconRenderer","path":"IconRenderer.html","kind":"module","full_name":"IconRenderer","name":"IconRenderer","abstract":false,"locations":[{"filename":"src/gd-icon-renderer.cr","line_number":9,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L9"},{"filename":"src/lib/plist/generator.cr","line_number":4,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/lib/plist/generator.cr#L4"}],"repository_name":"gd-icon-renderer","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"0.1.0\""}],"extended_modules":[{"html_id":"gd-icon-renderer/IconRenderer","kind":"module","full_name":"IconRenderer","name":"IconRenderer"}],"types":[{"html_id":"gd-icon-renderer/IconRenderer/Assets","path":"IconRenderer/Assets.html","kind":"module","full_name":"IconRenderer::Assets","name":"Assets","abstract":false,"locations":[{"filename":"src/gd-icon-renderer.cr","line_number":23,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L23"}],"repository_name":"gd-icon-renderer","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"GAME_SHEET_02","name":"GAME_SHEET_02","value":"{load_plist(\"GJ_GameSheet02-uhd.plist\"), \"GJ_GameSheet02-uhd\"}"},{"id":"GAME_SHEET_GLOW","name":"GAME_SHEET_GLOW","value":"{load_plist(\"GJ_GameSheetGlow-uhd.plist\"), \"GJ_GameSheetGlow-uhd\"}"}],"extended_modules":[{"html_id":"gd-icon-renderer/IconRenderer/Assets","kind":"module","full_name":"IconRenderer::Assets","name":"Assets"}],"namespace":{"html_id":"gd-icon-renderer/IconRenderer","kind":"module","full_name":"IconRenderer","name":"IconRenderer"},"instance_methods":[{"html_id":"load(path:String,assets:Tuple(PList::Value,String))-instance-method","name":"load","doc":"Load a given asset. `path` acts as the name, while `assets` is a tuple of the parsed .plist file and its name; see `load_plist`.","summary":"<p>Load a given asset.</p>","abstract":false,"args":[{"name":"path","external_name":"path","restriction":"String"},{"name":"assets","external_name":"assets","restriction":"Tuple(PList::Value, String)"}],"args_string":"(path : String, assets : Tuple(PList::Value, String))","args_html":"(path : String, assets : Tuple(PList::Value, String))","location":{"filename":"src/gd-icon-renderer.cr","line_number":37,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L37"},"def":{"name":"load","args":[{"name":"path","external_name":"path","restriction":"String"},{"name":"assets","external_name":"assets","restriction":"Tuple(PList::Value, String)"}],"visibility":"Public","body":"if File.exists?(\"#{assets[1]}/#{path}\")\n  {Vips::Image.new_from_file(\"#{assets[1]}/#{path}\"), ((assets[0])[\"frames\"].as(Hash(String, PList::Value)))[\"#{path}\"].as(Hash(String, PList::Value))}\nelse\n  nil\nend"}},{"html_id":"load_plist(path:String)-instance-method","name":"load_plist","doc":"Loads a .plist file and parses it. Made as a quick shorthand.","summary":"<p>Loads a .plist file and parses it.</p>","abstract":false,"args":[{"name":"path","external_name":"path","restriction":"String"}],"args_string":"(path : String)","args_html":"(path : String)","location":{"filename":"src/gd-icon-renderer.cr","line_number":27,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L27"},"def":{"name":"load_plist","args":[{"name":"path","external_name":"path","restriction":"String"}],"visibility":"Public","body":"(File.open(path) do |file|\n  PList.parse(file)\nend).not_nil!"}}]},{"html_id":"gd-icon-renderer/IconRenderer/Renderer","path":"IconRenderer/Renderer.html","kind":"module","full_name":"IconRenderer::Renderer","name":"Renderer","abstract":false,"locations":[{"filename":"src/gd-icon-renderer.cr","line_number":50,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L50"}],"repository_name":"gd-icon-renderer","program":false,"enum":false,"alias":false,"const":false,"extended_modules":[{"html_id":"gd-icon-renderer/IconRenderer/Renderer","kind":"module","full_name":"IconRenderer::Renderer","name":"Renderer"}],"namespace":{"html_id":"gd-icon-renderer/IconRenderer","kind":"module","full_name":"IconRenderer","name":"IconRenderer"},"doc":"The main renderer module; familiarity with [CrystalVips](https://naqvis.github.io/crystal-vips/index.html) is highly recommended.","summary":"<p>The main renderer module; familiarity with <a href=\"https://naqvis.github.io/crystal-vips/index.html\">CrystalVips</a> is highly recommended.</p>","instance_methods":[{"html_id":"render_icon(filename:String,col1:Array(Float64),col2:Array(Float64))-instance-method","name":"render_icon","doc":"The main entrypoint for icon rendering; this should be all you need to render out an icon.\n\nExample:\n```\n# Render out the icon\nicon_img = IconRenderer::Renderer.render_icon(\"ship_44\", [0.0, 0.0, 0.0, 1.0], [255/255, 125/255, 125/255, 1.0])\n# Trim it out\nalpha = icon_img.extract_band(3)\nleft, top, width, height = alpha.find_trim(threshold: 0, background: [0])\nicon_img = icon_img.crop(left, top, width, height)\n# Write it to a file\nicon_img.write_to_file(\"icon_rendered.png\")\n```","summary":"<p>The main entrypoint for icon rendering; this should be all you need to render out an icon.</p>","abstract":false,"args":[{"name":"filename","external_name":"filename","restriction":"String"},{"name":"col1","external_name":"col1","restriction":"Array(Float64)"},{"name":"col2","external_name":"col2","restriction":"Array(Float64)"}],"args_string":"(filename : String, col1 : Array(Float64), col2 : Array(Float64))","args_html":"(filename : String, col1 : Array(Float64), col2 : Array(Float64))","location":{"filename":"src/gd-icon-renderer.cr","line_number":82,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L82"},"def":{"name":"render_icon","args":[{"name":"filename","external_name":"filename","restriction":"String"},{"name":"col1","external_name":"col1","restriction":"Array(Float64)"},{"name":"col2","external_name":"col2","restriction":"Array(Float64)"}],"visibility":"Public","body":"layers = [Assets.load(\"#{filename}_glow_001.png\", Assets::GAME_SHEET_GLOW), Assets.load(\"#{filename}_2_001.png\", Assets::GAME_SHEET_02), Assets.load(\"#{filename}_3_001.png\", Assets::GAME_SHEET_02), Assets.load(\"#{filename}_001.png\", Assets::GAME_SHEET_02), Assets.load(\"#{filename}_extra_001.png\", Assets::GAME_SHEET_02)]\ncolors = [col2, col2, nil, col1, nil]\ni = -1\nrender_layered(layers.select do |v|\n  v != nil\nend.map do |t|\n  t.not_nil![0]\nend, layers.select do |v|\n  v != nil\nend.map do |t|\n  parse_vec(t.not_nil![1].not_nil![\"spriteSourceSize\"].as(String))\nend, colors.select do |v|\n  layers[(  i = i + 1)]?\nend)\n"}},{"html_id":"render_layered(images:Array(Vips::Image),sizes:Array(Tuple(Int32,Int32)),colors:Array(Array(Float64)|Nil))-instance-method","name":"render_layered","abstract":false,"args":[{"name":"images","external_name":"images","restriction":"Array(Vips::Image)"},{"name":"sizes","external_name":"sizes","restriction":"Array(Tuple(Int32, Int32))"},{"name":"colors","external_name":"colors","restriction":"Array(Array(Float64) | ::Nil)"}],"args_string":"(images : Array(Vips::Image), sizes : Array(Tuple(Int32, Int32)), colors : Array(Array(Float64) | Nil))","args_html":"(images : Array(Vips::Image), sizes : Array(Tuple(Int32, Int32)), colors : Array(Array(Float64) | Nil))","location":{"filename":"src/gd-icon-renderer.cr","line_number":53,"url":"https://github.com/oatmealine/gd-icon-renderer/blob/96508370f223be8d3886ece112f9f3337093061a/src/gd-icon-renderer.cr#L53"},"def":{"name":"render_layered","args":[{"name":"images","external_name":"images","restriction":"Array(Vips::Image)"},{"name":"sizes","external_name":"sizes","restriction":"Array(Tuple(Int32, Int32))"},{"name":"colors","external_name":"colors","restriction":"Array(Array(Float64) | ::Nil)"}],"visibility":"Public","body":"bounding_box = sizes.reduce do |p1, p2|\n  {Math.max(p1[0], p2[0]), Math.max(p1[1], p2[1])}\nend\n(colors[0]? ? images[0] * colors[0] : images[0]).embed(x: Int32.new((bounding_box[0] / 2) - (sizes[0][0] / 2)), y: Int32.new((bounding_box[1] / 2) - (sizes[0][1] / 2)), width: bounding_box[0], height: bounding_box[1]).composite(images[1..].map_with_index do |img, i|\n  colors[i + 1]? ? img * colors[i + 1] : img\nend, [Vips::Enums::BlendMode::Over], x: sizes[1..].map do |v|\n  (bounding_box[0] / 2) - (v[0] / 2)\nend, y: sizes[1..].map do |v|\n  (bounding_box[1] / 2) - (v[1] / 2)\nend)\n"}}]}]}]}})