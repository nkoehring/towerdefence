module TowerDefence
  class GlobalEventHandler
    include EventHandler::HasEventHandler

    def initialize clock, handle_sdl_events=true
      @clock = clock
      @clock.enable_tick_events
      @handle_sdl = handle_sdl_events

      # Create an EventQueue to take events from the keyboard, etc.
      # The events are taken from the queue and passed to objects
      # as part of the main loop.
      @queue = EventQueue.new()
      @queue.enable_new_style_events
    end

    def fire event
      @queue << event
    end

    def update
      # Fetch input events, etc. from SDL, and add them to the queue.
      @queue.fetch_sdl_events if @handle_sdl

      # Tick the clock and add the TickEvent to the queue.
      @queue << @clock.tick

      # Process all the events on the queue.
      @queue.each do |e|
        handle(e)
      end
    end
  end
end
