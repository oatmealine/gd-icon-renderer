# Various game constants
module IconRenderer::Constants
  # Nabbed from https://github.com/GDColon/GDBrowser/blob/master/iconkit/sacredtexts/colors.json
  # Default colors given to you in vanilla GD
  COLORS = [
    [125/255, 255/255, 0/255,   1.0],
    [0/255,   255/255, 0/255,   1.0],
    [0/255,   255/255, 125/255, 1.0],
    [0/255,   255/255, 255/255, 1.0],
    [0/255,   125/255, 255/255, 1.0],
    [0/255,   0/255,   255/255, 1.0],
    [125/255, 0/255,   255/255, 1.0],
    [255/255, 0/255,   255/255, 1.0],
    [255/255, 0/255,   125/255, 1.0],
    [255/255, 0/255,   0/255,   1.0],
    [255/255, 125/255, 0/255,   1.0],
    [255/255, 255/255, 0/255,   1.0],
    [255/255, 255/255, 255/255, 1.0],
    [185/255, 0/255,   255/255, 1.0],
    [255/255, 185/255, 0/255,   1.0],
    [0/255,   0/255,   0/255,   1.0],
    [0/255,   200/255, 255/255, 1.0],
    [175/255, 175/255, 175/255, 1.0],
    [90/255,  90/255,  90/255,  1.0],
    [255/255, 125/255, 125/255, 1.0],
    [0/255,   175/255, 75/255,  1.0],
    [0/255,   125/255, 125/255, 1.0],
    [0/255,   75/255,  175/255, 1.0],
    [75/255,  0/255,   175/255, 1.0],
    [125/255, 0/255,   125/255, 1.0],
    [175/255, 0/255,   75/255,  1.0],
    [175/255, 75/255,  0/255,   1.0],
    [125/255, 125/255, 0/255,   1.0],
    [75/255,  175/255, 0/255,   1.0],
    [255/255, 75/255,  0/255,   1.0],
    [150/255, 50/255,  0/255,   1.0],
    [150/255, 100/255, 0/255,   1.0],
    [100/255, 150/255, 0/255,   1.0],
    [0/255,   150/255, 100/255, 1.0],
    [0/255,   100/255, 150/255, 1.0],
    [100/255, 0/255,   150/255, 1.0],
    [150/255, 0/255,   100/255, 1.0],
    [150/255, 0/255,   0/255,   1.0],
    [0/255,   150/255, 0/255,   1.0],
    [0/255,   0/255,   150/255, 1.0],
    [125/255, 255/255, 175/255, 1.0],
    [125/255, 125/255, 255/255, 1.0],
  ]

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
