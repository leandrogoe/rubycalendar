require 'location'

class Event
  attr_accessor :start_time, :end_time
  
  def initialize(name, params)
    raise ArgumentError.new("Parameter name is required" ) unless name
    raise ArgumentError.new("Parameter start_time is required" ) unless params[:start_time]
    raise ArgumentError.new("You must either supply end_time or set all_day to true") unless params[:end_time] || params[:all_day]
    
    @name = name
    update_event(params)
  end
  def update_event(params)
    @all_day = params[:all_day].nil? ? false : params[:all_day]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
    if(!params[:location].nil?)
      if(@location.nil?)
        @location = Location.new(params[:location])
      else
        @location.update(params[:location])     
      end
    end
  end
  def to_s
    event_description = "# #{@name}\n" 
    if(!@all_day)
      event_description += "# ...Starts #{@start_time.strftime("%B %d, %Y at %r")}\n" \
                           "# ...Ends #{@end_time.strftime("%B %d, %Y at %r")}\n"
    else
      event_description += "# ...Date: #{@start_time.strftime("%B %d, %Y")} (All Day)\n"
    end 
    if(!@location.nil?)
      event_description += "# ...Location: #{@location}\n"
    end
    event_description += "# ---------------------------------------------------------------------\n"
    event_description
  end
  def inspect
    "\n" + to_s
  end
  def is_for_date?(date)
    start_time.to_date == date || (!end_time.nil? && end_time.to_date == date) 
  end
  def is_for_this_week?()
    daysDifference = start_time.to_date - Date.today
    daysDifference > 0 && daysDifference <= 7 
  end
end