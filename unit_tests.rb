require 'calendar.rb'
require "test/unit"

class Unit_tests < Test::Unit::TestCase
  
  def create_cathys_party(cal)
    event = cal.add_event("Cathy's Party",     # name is required
      all_day: false,                          # all_day is optional (defaults to false)
      start_time: Time.new(2017, 8, 4, 20, 0), # start_time is required
      end_time: Time.new(2017, 8, 4, 23, 59),  # end_time is required UNLESS all_day is true
      location: {                              # location is optional
        name: 'Barcade',                         # name is required
        address: '148 W 24th St',                # address is optional
        city: 'New York',                        # city is optional
        state: 'NY',                             # state is optional
        zip: '10011'                             # zip is optional
      }
    )
  end
  
  def test_create_update_event
    cal = Calendar.new("My calendar")
    event = create_cathys_party(cal)
    
    assert_equal("Cathy's Party", event.name)
    assert_equal(Time.new(2017, 8, 4, 20, 0), event.start_time)
    assert_equal(Time.new(2017, 8, 4, 23, 59), event.end_time)
    assert_equal('Barcade', event.location.name)
    assert_equal('148 W 24th St', event.location.address)
    assert_equal('New York', event.location.city)
    assert_equal('NY', event.location.state)
    assert_equal('10011', event.location.zip())
    
    assert_equal(  
    "# Cathy's Party\n" \
    "# ...Starts August 04, 2017 at 08:00:00 PM\n" \
    "# ...Ends August 04, 2017 at 11:59:00 PM\n" \
    "# ...Location: Barcade, 148 W 24th St, New York, NY, 10011\n" \
    "# ---------------------------------------------------------------------\n",
    event.to_s())
    
    cal.update_events("Cathy's Party",
      {
        location:
        {
          zip: '12345'
        }
      })
    
    # Only the zip code should have changed
    assert_equal(  
        "# Cathy's Party\n" \
        "# ...Starts August 04, 2017 at 08:00:00 PM\n" \
        "# ...Ends August 04, 2017 at 11:59:00 PM\n" \
        "# ...Location: Barcade, 148 W 24th St, New York, NY, 12345\n" \
        "# ---------------------------------------------------------------------\n",
        event.to_s())
  end
  
  def test_parameter_validation
    cal = Calendar.new("My calendar")
    
    # Try creating an event without a start time, should fail
    exception = assert_raise(ArgumentError) {
      cal.add_event("Without a start time",
      all_day: false,
      end_time: Time.new(2017, 8, 4, 23, 59) 
    )}
    
    assert_equal('Parameter start_time is required', exception.message)
    
    # Try creating an event without an end time, should fail
    exception = assert_raise(ArgumentError) {
      cal.add_event("Without a start time",
      start_time: Time.new(2017, 8, 4, 23, 59) 
    )}
    
    assert_equal('Either end_time should be supplied or all_day set to true', exception.message)
    
    # Try creating a whole day event, should work
    cal.add_event("A whole day event", 
      start_time: Time.new(2017, 8, 4, 23, 59),
      all_day: true)
      
    assert_equal(1, cal.events.count)
    assert_equal("A whole day event", cal.events[0].name)
    
    # Try creating an event which ends before it starts, should fail
    exception = assert_raise(ArgumentError) {
      cal.add_event("Ends before it starts",
      start_time: Time.new(2017, 8, 5, 1, 59),
      end_time: Time.new(2017, 8, 4, 23, 59) 
    )}
    
    assert_equal('Start date should be lower than the end date', exception.message)
  end
  
  def test_find_event
    cal = Calendar.new("My calendar")
    create_cathys_party(cal)
    
    events = cal.events_with_name("Cathy's Party")
    assert_equal(1, events.count)
    assert_equal("Cathy's Party", events[0].name)
    
    events = cal.events_with_name("Leandro's Party")
    assert_equal(0, events.count)
    
    events = cal.events_for_date(Date.new(2017, 8, 4))
    assert_equal(1, events.count)
    assert_equal("Cathy's Party", events[0].name)
    
    events = cal.events_for_date(Date.new(2017, 8, 5))
    assert_equal(0, events.count)
    
    # Regex support
    events = cal.events_with_pattern(/Start/)
    assert_equal(0, events.count)
    
    events = cal.events_with_pattern(/New\s+Yo/)
    assert_equal(1, events.count)
  end
  
  
  def test_find_event_dates
    cal = Calendar.new("My calendar")
    cal.add_event('This is an event for today',
      start_time: Date.today().to_time() + 10.5*60*60,
      end_time: Date.today().to_time() + 11*60*60,
      location: {
        name: 'At home'
      }
    )
    
    cal.add_event('This is also an event for today, but starts yesterday',
      start_time: Date.today().to_time() - 1*60*60,
      end_time: Date.today().to_time() + 1*60*60,
      location: {
        name: 'At home'
      }
    )
    
    cal.add_event('This is an event for this week',
      start_time: Time.now() + 3*24*60*60,
      end_time: Time.now() + 3.2*24*60*60,
      location: {
        name: 'Montevideo, Uruguay'
      }
    )
    
    start_time = Time.now() + 100*24*60*60
    end_time = Time.now() + 100.4*24*60*60
    
    cal.add_event('Not an event for this week',
      start_time: start_time,
      end_time: end_time,
      location: {
        name: 'Montevideo, Uruguay'
      }
    )
    
    events_today = cal.events_for_today
    assert_equal(2, events_today.count)
    assert_equal(1, events_today.select{ |event| event.name == 'This is also an event for today, but starts yesterday' }.count)
    assert_equal(1, events_today.select{ |event| event.name == 'This is an event for today' }.count)
      
    events_this_week = cal.events_for_this_week()
    assert_equal(3, events_this_week.count)
    assert_equal(1, events_this_week.select{ |event| event.name == 'This is also an event for today, but starts yesterday' }.count)
    assert_equal(1, events_this_week.select{ |event| event.name == 'This is an event for today' }.count)
    assert_equal(1, events_this_week.select{ |event| event.name == 'This is an event for this week' }.count)
    
    events_date = cal.events_for_date(start_time.to_date)
    assert_equal(1, events_date.count)
    assert_equal('Not an event for this week', events_date[0].name)
  end 
  
  def test_times_as_strings
    cal = Calendar.new("My calendar")
    create_cathys_party(cal)
    
    events = cal.events_for_date('5th may 2017')
    assert_equal(0, events.count)
    
    events = cal.events_for_date('4th august 2017')
    assert_equal(1, events.count)
    
    event = cal.add_event('An event created with times as strings',
      start_time: 'Tomorrow 4pm',
      end_time: 'Tomorrow 5:30pm',
      location: {
        name: 'Montevideo, Uruguay'
      }
    )
    
    expected_start = Date.today.to_time + 16*60*60 + 24*60*60 
    expected_end = Date.today.to_time + 17.5*60*60 + 24*60*60
    
    assert_equal(expected_start, event.start_time())
    assert_equal(expected_end, event.end_time())
  end
end