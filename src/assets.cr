# Module handling game assets
module IconRenderer::Assets
  extend self

  # `"{1,2}"` -> `{1, 2}`
  def parse_vec(str : String) : {Int32, Int32}
    a = str[1..-2].split(",").map { |v| Int32.new(v) }
    {a[0], a[1]}
  end
  # `parse_vec`, except for Float32s
  def parse_vec_f(str : String) : {Float32, Float32}
    a = str[1..-2].split(",").map { |v| Float32.new(v) }
    {a[0], a[1]}
  end
  # `"{{1,2},{3,4}}"` -> `{{1, 2}, {3, 4}}`
  def parse_rect_vecs(str : String) : { {Int32, Int32}, {Int32, Int32} }
    a = str.gsub(/[{}]/, "").split(",").map { |v| Int32.new(v) }
    { {a[0], a[1]}, {a[2], a[3]} }
  end

  # Represents a sprite along with its texture data in a spritesheet.
  class Sprite
    # Whenever rendering the sprite, offset it by this much
    getter offset : {Float32, Float32}
    # {left, top}, {width, height}. Controls the cropping
    getter rect : { {Int32, Int32}, {Int32, Int32} }
    # Whether the texture needs to be counter-rotated 90deg counter-clockwise
    getter rotated : Bool
    getter size : {Int32, Int32}
    # Difference between this and `size` is unknown as of now
    getter source_size : {Int32, Int32}

    def initialize(@offset : {Int32, Int32}, @rect : { {Int32, Int32}, {Int32, Int32} }, @rotated : Bool, @size : {Int32, Int32}, @source_size : {Int32, Int32})
    end

    # Shorthand for initializing a sprite with its .plist representation.
    def initialize(obj : PList::Value)
      hash = obj.as?(Hash)
      if !hash
        raise "Object must be a dict"
      end

      isolated = ["spriteOffset", "spriteSize", "spriteSourceSize", "textureRect", "textureRotated"]
        .map { |s| {s, hash[s]?} }

      missing = isolated.select { |t| t[1] == nil }
      if missing.size > 0
        raise "Missing entries for: #{missing.map { |t| t[0] }}"
      end

      isolated_hash = Hash.zip(isolated.map { |t| t[0] }, isolated.map { |t| t[1] })

      @offset = Assets.parse_vec_f(isolated_hash["spriteOffset"].as(String))
      @rect = Assets.parse_rect_vecs(isolated_hash["textureRect"].as(String))
      @rotated = isolated_hash["textureRotated"].as?(Bool) || false
      @size = Assets.parse_vec(isolated_hash["spriteSize"].as(String))
      @source_size = Assets.parse_vec(isolated_hash["spriteSourceSize"].as(String))
    end
  end

  # Represents the metadata of a spritesheet and its sprites.
  class Spritesheet
    getter sprites : Hash(String, Sprite)

    getter texture_file_name : String
    getter size : {Int32, Int32}

    def initialize(@sprites : Hash(String, Sprite), @texture_file_name : String, @size : {Int32, Int32})
    end

    # Shorthand for initializing a spritesheet with its .plist representation.
    def initialize(obj : PList::Value)
      hash = obj.as?(Hash)
      if !hash
        raise "Object must be a dict"
      end

      sprites = hash["frames"]?.as?(Hash)
      if !sprites
        raise "Object must have a `frames` dict"
      end
      metadata = hash["metadata"]?.as?(Hash)
      if !metadata
        raise "Object must have a `metadata` dict"
      end

      @sprites = Hash.zip(sprites.map { |key, value| key }, sprites.map { |key, value| Sprite.new(value) })

      @texture_file_name = metadata["textureFileName"].as(String)
      @size = Assets.parse_vec(metadata["size"].as(String))
    end
  end

  # Loads a .plist file and parses it.
  def load_plist(path : String | Path)
    File.open(path) { |file|
      PList.parse(file)
    }
  end

  # :ditto:
  def load_plist(io : IO)
    PList.parse(io)
  end

  # Loads a .plist file and parses it into a spritesheet.
  def parse_spritesheet(path : String | Path)
    plist = load_plist(path)
    if !plist
      raise "Failed to parse plist"
    end
    Spritesheet.new(plist)
  end

  # :ditto:
  def parse_spritesheet(io : IO)
    plist = load_plist(io)
    Spritesheet.new(plist)
  end

  # Stores both a spritesheet and its associated `Vips::Image` for ease of use.
  record LoadedSpritesheet, sheet : Spritesheet, image : Vips::Image

  # Loads the spritesheet and readies the associated image.
  def load_spritesheet(path : Path)
    spritesheet = parse_spritesheet(path)
    image_path = path.parent / spritesheet.texture_file_name
    LoadedSpritesheet.new(spritesheet, Vips::Image.new_from_file(image_path.to_s))
  end

  # :ditto:
  def load_spritesheet(path : String)
    load_spritesheet(Path.new(path))
  end

  # Represents the metadata of an animation frame's sprite
  class AnimationSprite
    getter texture : String
    getter position : {Float32, Float32}
    getter scale : {Float32, Float32}
    getter rotation : Float64
    getter flipped : {Bool, Bool}
    getter z : Int32

    def initialize(@texture : String, @position : {Float32, Float32}, @scale : {Float32, Float32}, @rotation : Float64, @flipped : {Int32, Int32}, @z : Int32)
    end

    def initialize(obj : PList::Value)
      hash = obj.as?(Hash)
      if !hash
        raise "Object must be a dict"
      end

      isolated = ["texture", "position", "scale", "rotation", "flipped", "zValue"]
        .map { |s| {s, hash[s]?} }

      missing = isolated.select { |t| t[1] == nil }
      if missing.size > 0
        raise "Missing entries for: #{missing.map { |t| t[0] }}"
      end

      isolated_hash = Hash.zip(isolated.map { |t| t[0] }, isolated.map { |t| t[1] })

      @texture = isolated_hash["texture"].as(String)
      @position = Assets.parse_vec_f(isolated_hash["position"].as(String))
      @scale = Assets.parse_vec_f(isolated_hash["scale"].as(String))
      @rotation = Float64.new(isolated_hash["rotation"].as(String))
      @flipped = Assets.parse_vec(isolated_hash["flipped"].as(String)).map { |v| v > 0 }
      @z = Int32.new(isolated_hash["zValue"].as(String))
    end
  end

  alias Animations = Hash(String, Array(AnimationSprite))

  # Load an animations plist file.
  def load_animations(io : IO)
    plist = load_plist(io)
    animations = plist.as(Hash)["animationContainer"].as(Hash)
    animations_parsed = {} of String => Array(AnimationSprite)
    animations.each do |k, v|
      animations_parsed[k] = [] of AnimationSprite
      values = v.as(Hash).each { |_, v| animations_parsed[k] << AnimationSprite.new(v.as(Hash)) }
    end
    animations_parsed
  end

  def load_animations(path : Path | String)
    File.open(path) { |file| load_animations(file) }
  end

  # Trims out a sprite from an image according to a .plist spritesheet.
  def get_sprite(spritesheet : Spritesheet, img : Vips::Image, key : String)
    sprite = spritesheet.sprites[key]?

    if !sprite
      return nil
    end

    rect = sprite.rect

    left, top, width, height = rect[0][0], rect[0][1], rect[1][0], rect[1][1]
    if sprite.rotated
      left, top, width, height = left, top, height, width
    end

    img = img.crop(left, top, width, height)

    if sprite.rotated
      img = img.rot(Vips::Enums::Angle::D270)
    end

    {img, sprite}
  end

  # :ditto:
  def get_sprite(spritesheet : LoadedSpritesheet, key : String)
    get_sprite(spritesheet.sheet, spritesheet.image, key)
  end
end
