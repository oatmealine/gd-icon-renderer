require "option_parser"
require "vips"
require "./lib/plist.cr"

require "./constants.cr"
require "./assets.cr"
require "./renderer.cr"

module IconRenderer
  extend self

  VERSION = "0.1.0"
end