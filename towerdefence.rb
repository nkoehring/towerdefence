#!/usr/bin/env ruby

require 'rubygame'
# fake vectors
require 'rubygame/ftor'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers


require './classes/configuration'
require './classes/grid'
require './classes/tower'
require './classes/game'


# Start the main game loop.
# It will repeat forever until the user quits the game.
Game.new.go


# Make sure everything is cleaned up properly.
Rubygame.quit()

