# Module handling game assets
module IconRenderer::Assets
  extend self

  # Loads a .plist file and parses it. Made as a quick shorthand.
  def load_plist(path : String)
    File.open(path) { |file|
      PList.parse(file)
    }.not_nil!
  end

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
