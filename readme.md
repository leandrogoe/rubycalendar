# Ruby Calendar

A quick and (extremely basic) in-memory calendar library and console app made in ruby. Chronic gem is required for date string parsing.

# The library

The library consists of three classes:
- Calendar
- Event
- Location

Calendar class offers the following functions:

- `#add_event(name, params)` – Adds an event to the calendar. 
- `#events` – Returns all events for the calendar.
- `#events_with_name(name)` – Returns events matching the given name.
- `#events_with_pattern(regex)` – Returns all the events that match a given regular expression.
- `#events_for_date(date)` – Returns events that occur during the given date.
- `#events_for_today` – Returns events that occur today.
- `#events_for_this_week` – Returns events that occur within the next 7 days.
- `#update_events(name, params)` – For all calendar events matching the given name, then update the event's attributes based on the given params.
- `#remove_events(name)` – Removes calendar events with the given name.

Despite none of these methods write to the standard output, users may still interact with the library through the irb console and recieve human readable output. 
This is possible because classes have descriptive strings returned in the inspect method.

Some examples:
```ruby
>irb -I . -r ./calendar.rb
irb(main):001:0> cal = Calendar.new("My calendar")
=> #<Calendar:0x0000000002b2acf8 @name="My calendar", @events=[]>
irb(main):002:0> cal.add_event("See a film somewhere",
irb(main):003:1*   start_time: "Today 9 pm",
irb(main):004:1*   end_time: "Today 10 pm")
=>
'# See a film somewhere'
'# ...Starts October 29, 2017 at 09:00:00 PM'
'# ...Ends October 29, 2017 at 10:00:00 PM'
'# ---------------------------------------------------------------------'

irb(main):010:0> cal.add_event("Do the dishes",
irb(main):011:1*    start_time: "Next monday, 1pm",
irb(main):012:1*    end_time: "Next monday, 2pm",
irb(main):013:1*    location: {
irb(main):014:2*       name: "At home"
irb(main):015:2>    })
=>
'# Do the dishes'
'# ...Starts October 30, 2017 at 01:00:00 PM'
'# ...Ends October 30, 2017 at 02:00:00 PM'
'# ...Location: At home'
'# ---------------------------------------------------------------------'

irb(main):016:0> cal.events
=> [
'# See a film somewhere'
'# ...Starts October 29, 2017 at 09:00:00 PM'
'# ...Ends October 29, 2017 at 10:00:00 PM'
'# ---------------------------------------------------------------------'
,
'# Do the dishes'
'# ...Starts October 30, 2017 at 01:00:00 PM'
'# ...Ends October 30, 2017 at 02:00:00 PM'
'# ...Location: At home'
'# ---------------------------------------------------------------------'
]
irb(main):017:0> cal.events_with_pattern(/home/)
=> [
'# Do the dishes'
'# ...Starts October 30, 2017 at 01:00:00 PM'
'# ...Ends October 30, 2017 at 02:00:00 PM'
'# ...Location: At home'
'# ---------------------------------------------------------------------'
]
```
  
# The console app

The project also consists of a console app which can be used in a more intuitive way than a raw irb session. A brief example of what a session looks like is provided below.

```
C:\Users\Leandro\eclipse-workspace\RubyCalendar>irb -I . -r ./mainLoop.rb
Welcome to the calendar app!
>help
Available commands:
help
create_calendar
open_calendar
add_event
update_events
events_with_name
events_with_pattern
events_for_date
events_for_today
events_for_this_week
remove_events
events
quit
>create_calendar
Calendar Name:Leandro's calendar
>add_event
Name:Go to the cinema
Start Time:Today, 9 pm
All Day?:
End Time:Today, 10 pm
Location Name:
'# Go to the cinema'
'# ...Starts October 29, 2017 at 09:00:00 PM'
'# ...Ends October 29, 2017 at 10:00:00 PM'
'# ---------------------------------------------------------------------'
>events_for_today
[
'# Go to the cinema'
'# ...Starts October 29, 2017 at 09:00:00 PM'
'# ...Ends October 29, 2017 at 10:00:00 PM'
'# ---------------------------------------------------------------------'
]
>add_event
Name:Meet with Patrick
Start Time:Tomorrow, 10 am
All Day?:No
End Time:Tomorrow 11 am
Location Name:The office
Address:
City:
State:
Zip:
'# Meet with Patrick'
'# ...Starts October 30, 2017 at 10:00:00 AM'
'# ...Ends October 30, 2017 at 11:00:00 AM'
'# ...Location: The office'
'# ---------------------------------------------------------------------'
>events_for_this_week
[
'# Go to the cinema'
'# ...Starts October 29, 2017 at 09:00:00 PM'
'# ...Ends October 29, 2017 at 10:00:00 PM'
'# ---------------------------------------------------------------------'
,
'# Meet with Patrick'
'# ...Starts October 30, 2017 at 10:00:00 AM'
'# ...Ends October 30, 2017 at 11:00:00 AM'
'# ...Location: The office'
'# ---------------------------------------------------------------------'
]
>
```

# Tests

A simple set of unit tests was developed using test-unit. To run them simply type:

```
ruby -I . unit_tests.rb
Loaded suite unit_tests
Started
.....

Finished in 0.006005 seconds.
--------------------------------------------------------------------------------

5 tests, 39 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notific
ations
100% passed
--------------------------------------------------------------------------------
```
