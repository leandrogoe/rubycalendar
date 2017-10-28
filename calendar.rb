require 'event'
require 'date'

class Calendar
  def initialize(name)
    @name = name
    @events = Hash.new()
  end
  def add_event(name, params = {})
    if(@events.key?(name))
      raise Exception.new("Event already exists") 
    end
    
    event = Event.new(name, params)
    @events[name] = event
  end
  def update_events(name, params)
    if(!@events.key?(name))
      raise Exception.new("Event does not exist") 
    end
    
    @events[name].update_event(params)
    @events[name]
  end
  def events_with_name(name)
    if(!@events.key?(name))
      raise Excepion.new("Event does not exist")
    end if
    @events[name]
  end 
  def events_for_date(date)
    for_date = @events.select() { |name, event| event.is_for_date?(date) }
    for_date.collect() { |event_name, event| event }
  end if
  def events_for_today()
    events_for_date(Date.today())
  end
  def events_for_this_week()
    for_week = @events.select() { |name, event| event.is_for_this_week?() }
    for_week.collect() { |event_name, event| event }
  end
  def remove_events(name)
    if(!@events.key?(name))
      raise Exception.new("Event does not exist") 
    end
    
    event = @events[name]
    @events.delete(name)
    event
  end 
  def events()
    @events.collect() { |event_name, event| event }
  end
end