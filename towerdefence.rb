#!/usr/bin/env ruby

require 'rubygame'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers


require './classes/configuration'
require './classes/global_event_handler'
require './classes/grid'
require './classes/enemy'
require './classes/tower'
require './classes/hud'
require './classes/game'


# Start the main game loop.
# It will repeat forever until the user quits the game.
TowerDefence::Game.new.go


# Make sure everything is cleaned up properly.
Rubygame.quit()

