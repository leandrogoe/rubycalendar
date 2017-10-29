require 'Calendar'
require 'Date'

puts "#######################################################################"
puts "                              Creating events                          "
puts "#######################################################################"

cal = Calendar.new("Cathy's Calendar")
cal.add_event("Cathy's Party",             # name is required
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

cal.add_event('Brunch with Friends',
  start_time: Time.new(2017, 8, 5, 11, 30),
  end_time: Time.new(2017, 8, 5, 13, 0),
  location: {
    name: "Jack's Wife Freda",
    address: '224 Lafayette St',
    city: 'New York',
    state: 'NY',
    zip: '10012'
  }
)

cal.add_event('Dog Walking',
  start_time: Time.new(2017, 8, 5, 15, 30),
  end_time: Time.new(2017, 8, 5, 16, 30),
  location: {
    name: 'Brooklyn Paws, Inc.',
    address: '110 York St',
    city: 'Brooklyn',
    state: 'NY',
    zip: '11201'
  }
)

cal.add_event("Andy Warhol's Birthday",
  all_day: true,
  start_time: Time.new(2017, 8, 6)
)

cal.add_event('Cipherhealth Interview',
  start_time: Time.new(2017, 8, 8, 14, 00),
  end_time: Time.new(2017, 8, 8, 15, 30),
  location: {
    name: 'Cipherhealth',
    address: '555 8th Ave',
    city: 'New York',
    state: 'NY',
    zip: '10018'
  }
)

cal.add_event('VACATION!',
  start_time: Time.new(2017, 8, 19, 10),
  end_time: Time.new(2017, 8, 27, 14, 0),
  location: {
    name: 'Tulum, Mexico'
  }
)

cal.add_event('This is an event for today',
  start_time: Date.today().to_time() + 10.5*60*60,
  end_time: Date.today().to_time() + 11*60*60,
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

cal.add_event('Not an event for this week',
  start_time: Time.now() + 100*24*60*60,
  end_time: Time.now() + 100.4*24*60*60,
  location: {
    name: 'Montevideo, Uruguay'
  }
)


puts "#######################################################################"
puts "                Listing all events in the calendar                     "
puts "#######################################################################"

events = cal.events()

puts "#{events}"

puts "#######################################################################"
puts "                  Listing events with a given name                     "
puts "#######################################################################"
  
events = cal.events_with_name("Cathy's Party")

puts "#{events}"

puts "#######################################################################"
puts "                   Listing events for a given date                     "
puts "#######################################################################"
events = cal.events_for_date(Date.new(2017, 8, 4))

puts "#{events}"

puts "#######################################################################"
puts "                      Listing events for today                         "
puts "#######################################################################"
events = cal.events_for_today

puts "#{events}"

puts "#######################################################################"
puts "                        Listing for this week                          "
puts "#######################################################################"
events = cal.events_for_this_week

puts "#{events}"

puts "#######################################################################"
puts "                           Updating event                              "
puts "#######################################################################"

events = cal.update_events('Cipherhealth Interview',
  start_time: Time.new(2017, 8, 8, 15, 00),
  end_time: Time.new(2017, 8, 8, 16, 30)
)

puts "#{events}"

puts "#######################################################################"
puts "                             Remove event                              "
puts "#######################################################################"

events = cal.remove_events("Andy Warhol's Birthday")

puts "#{events}"

puts "#######################################################################"
puts "                            Listing events                             "
puts "#######################################################################"

events = cal.events()

puts "#{events}"


puts "#######################################################################"
puts "                          Finding with regex                           "
puts "#######################################################################"

events = cal.events_with_pattern(/Br.*nch/)

puts "#{events}" 

puts "#######################################################################"
puts "      Using strings instead of Time instances to create events         "
puts "#######################################################################"

event = cal.add_event('An event for tomorrow',
  start_time:  'Tomorrow',
  all_day: true,
  location: {
    name: 'Montevideo, Uruguay'
  }
)

puts "#{event}"

puts "#######################################################################"
puts "               Searching an event date with string                     "
puts "#######################################################################"

events = cal.events_for_date('4th august 2017')

puts "#{events}"