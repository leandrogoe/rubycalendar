require 'calendar'

class CalendarManager
  
  HELP="help"
  CREATE_CALENDAR="create_calendar"
  OPEN_CALENDAR="open_calendar"
  ADD_EVENT="add_event"
  UPDATE_EVENTS="update_events"
  EVENTS_WITH_NAME="events_with_name"
  EVENTS_WITH_PATTERN="events_with_pattern"
  EVENTS_FOR_DATE="events_for_date"
  EVENTS_FOR_TODAY="events_for_today"
  EVENTS_THIS_WEEK="events_for_this_week"
  REMOVE_EVENTS="remove_events"
  EVENTS="events"
  QUIT="quit"
  
  def self.get_commands
    [HELP,
    CREATE_CALENDAR,
    OPEN_CALENDAR,
    ADD_EVENT,
    UPDATE_EVENTS,
    EVENTS_WITH_NAME,
    EVENTS_WITH_PATTERN,
    EVENTS_FOR_DATE,
    EVENTS_FOR_TODAY,
    EVENTS_THIS_WEEK,
    REMOVE_EVENTS,
    EVENTS,
    QUIT]
  end
    
  def self.display_help
    puts "Available commands:\n" +
          "#{HELP}\n" +
          "#{CREATE_CALENDAR}\n" +
          "#{OPEN_CALENDAR}\n" +
          "#{ADD_EVENT}\n" +
          "#{UPDATE_EVENTS}\n" +
          "#{EVENTS_WITH_NAME}\n" +
          "#{EVENTS_WITH_PATTERN}\n" +
          "#{EVENTS_FOR_DATE}\n" +
          "#{EVENTS_FOR_TODAY}\n" +
          "#{EVENTS_THIS_WEEK}\n" +
          "#{REMOVE_EVENTS}\n" +
          "#{EVENTS}\n" +
          "#{QUIT}\n"
  end
  
  def self.promp_display
    print ">"
    STDOUT.flush
  end
  
  @@calendars = {}
  @@current_calendar = nil
  def self.create_calendar(name)
    if(@@calendars.key?(name))
      puts "Calendar already exists"
      return
    end
    @@current_calendar = Calendar.new(name)
    @@calendars[name] = @@current_calendar
  end
  
  def self.open_calendar(name)
    if(!@@calendars.key?(name))
      puts "Calendar does not exist"
      return
    end
    @@current_calendar = @@calendars[name]
  end
  
  def self.request_parameter(name, default_value = nil)
    print name + ":"
    STDOUT.flush
    param = gets.chomp
    if(param.empty?)
      param = default_value
    end
    param
  end
  
  def self.s_to_bool(boolean_string)
    conv = { 'true' => true, 'false' => false, 'yes' => true, 'no' => false}
    conv[boolean_string]
  end
  
  def self.request_parameters(command)
    params = []
    case command.downcase
    when CREATE_CALENDAR, OPEN_CALENDAR
      params[0] = request_parameter("Calendar Name")
    when ADD_EVENT, UPDATE_EVENTS
      params[0] = request_parameter("Name")
      params[1] = {
        start_time: request_parameter("Start Time"),
        all_day: s_to_bool(request_parameter("All Day?"))
     }
       
     params[1][:end_time] = request_parameter("End Time") unless params[1][:all_day];
     location_name = request_parameter("Location Name")
     
     if(location_name)
       params[1][:location] = {
            name: location_name,
            address: request_parameter("Address"),
            city: request_parameter("City"),
            state: request_parameter("State"),
            zip: request_parameter("Zip")
       }
     end
    when EVENTS_WITH_NAME, REMOVE_EVENTS
      params[0] = request_parameter("Name")
    when EVENTS_WITH_PATTERN
      params[0] = Regexp.new(request_parameter("Pattern"))
    when EVENTS_FOR_DATE
      params[0] = request_parameter("Date")
    when HELP, EVENTS_FOR_TODAY, EVENTS_THIS_WEEK, EVENTS
      # Do nothing, no parameters for these commands
    end
    params
  end
  
  def self.execute_command(command)
    
    case command.downcase
    when HELP
      display_help()
    when CREATE_CALENDAR
      params = request_parameters(command)
      create_calendar(params[0])
    when OPEN_CALENDAR
      params = request_parameters(command)
      open_calendar(params[0])
    else
      if(@@current_calendar.nil?)
        puts "Please open or create a calendar first"
        return
      end
      
      begin
        params = request_parameters(command)
        returnValue = @@current_calendar.send(command, *params)
        puts "#{returnValue}"
      rescue 
        puts "Error while executing command:\n #{$!}"
      end
    end
  end
end

puts 'Welcome to the calendar app!'
loop do
  CalendarManager.promp_display
  command = gets.chomp.strip

  if(command == CalendarManager::QUIT)
    return 0
  elsif (CalendarManager::get_commands().include?(command.downcase))
    CalendarManager.execute_command(command)
  else
    puts 'Invalid command!'
    CalendarManager.display_help
  end
end