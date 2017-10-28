require 'event'
require 'date'

class Calendar
  def initialize(name)
    @name = name
    @events = []
  end
  def add_event(name, params = {})    
    event = Event.new(name, params)
    @events.push(event)
    event
  end
  def update_events(name, params)
    events = events_with_name(name)
    events.each() { | event | event.update_event(params) } 
  end
  def events_with_name(name)
    @events.select(){ |event| event.name == name }
  end 
  def find_with_regex(regex)
    events.select() { | event | event.matches_regex?(regex) }
  end
  def events_for_date(date)
    @events.select() { |event| event.is_for_date?(date) }
  end if
  def events_for_today()
    events_for_date(Date.today())
  end
  def events_for_this_week()
    @events.select() { |event| event.is_for_this_week?() }
  end
  def remove_events(name)
    events = events_with_name(name)
    events.each{ | event | @events.delete(event) }
  end 
  def events()
    @events
  end
end