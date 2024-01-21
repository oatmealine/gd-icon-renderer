# Various game constants
module IconRenderer::Constants
  # :nodoc:
  def hex_to_rgb(hex : String)
    components = hex.scan(/.{2}/)
    red, green, blue = components.map(&.[0].to_i(16))
    return [red / 255, green / 255, blue / 255, 1.0]
  end

  # Default colors given to you in vanilla GD
  COLORS = begin
    hex_codes = [
      "7DFF00",
      "00FF00",
      "00FF7D",
      "00FFFF",
      "007DFF",
      "0000FF",
      "7D00FF",
      "FF00FF",
      "FF007D",
      "FF0000",
      "FF7D00",
      "FFFF00",
      "FFFFFF",
      "B900FF",
      "FFB900",
      "000000",
      "00C8FF",
      "AFAFAF",
      "5A5A5A",
      "FF7D7D",
      "00AF4B",
      "007D7D",
      "004BAF",
      "4B00AF",
      "7D007D",
      "AF004B",
      "AF4B00",
      "7D7D00",
      "4BAF00",
      "FF4B00",
      "963200",
      "966400",
      "649600",
      "009664",
      "006496",
      "640096",
      "960064",
      "960000",
      "009600",
      "000096",
      "7DFFAF",
      "7D7DFF",
      "FFFA7F",
      "FA7FFF",
      "00FFC0",
      "50320E",
      "CDA576",
      "B680FF",
      "FF3A3A",
      "4D4D8F",
      "000A4C",
      "FDD4CE",
      "BEB5FF",
      "700000",
      "520200",
      "380106",
      "804F4F",
      "7A3535",
      "512424",
      "A36246",
      "754936",
      "563528",
      "FFB972",
      "FFA040",
      "66311E",
      "5B2700",
      "472000",
      "A77B4D",
      "6D5339",
      "513E2A",
      "FFFFC0",
      "FDE0A0",
      "C0FFA0",
      "B1FF6D",
      "C0FFE0",
      "94FFE4",
      "43A18A",
      "316D5F",
      "265449",
      "006000",
      "004000",
      "006060",
      "004040",
      "A0FFFF",
      "010770",
      "00496D",
      "00324C",
      "002638",
      "5080AD",
      "335375",
      "233C56",
      "E0E0E0",
      "3D068C",
      "370860",
      "404040",
      "6F49A4",
      "54367F",
      "422A63",
      "FCB5FF",
      "AF57AF",
      "824382",
      "5E315E",
      "808080",
      "66033E",
      "470134",
      "D2FF32",
      "76BDFF",
    ]

    hex_codes.map { |c| hex_to_rgb(c) }
  end

  # `spicy` = uses 2.0 gamemode render system w/ multiple moving parts
  record Gamemode, prefix : String, spicy : Bool

  # Every gamemode in the game as of 2.2
  enum GamemodeType
    Cube
    Ship
    Ball
    Ufo
    Wave
    Robot
    Spider
    Jetpack
    Swing
  end

  # A mapping of GamemodeType to info about the gamemode
  Gamemodes = {
    GamemodeType::Cube =>    Gamemode.new("player_", false),
    GamemodeType::Ship =>    Gamemode.new("ship_", false),
    GamemodeType::Ball =>    Gamemode.new("player_ball_", false),
    GamemodeType::Ufo =>     Gamemode.new("bird_", false),
    GamemodeType::Wave =>    Gamemode.new("dart_", false),
    GamemodeType::Robot =>   Gamemode.new("robot_", true),
    GamemodeType::Spider =>  Gamemode.new("spider_", true),
    GamemodeType::Jetpack => Gamemode.new("jetpack_", false),
    GamemodeType::Swing =>   Gamemode.new("swing_", false),
  }
end
