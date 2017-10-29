require 'location'
require 'chronic'

class Event
  attr_accessor :start_time, :end_time, :name, :location
  
  def initialize(name, params)
    raise ArgumentError.new("Parameter name is required" ) unless name
    raise ArgumentError.new("Parameter start_time is required" ) unless params[:start_time]
    raise ArgumentError.new("Either end_time should be supplied or all_day set to true") unless params[:end_time] || params[:all_day]
    
    @name = name
    @all_day = false
    update_event(params)
  end
  def update_event(params)
    
    # Chronic support, allow strings instead of Time object instances
    start_time_param = params[:start_time]
    if(start_time_param.is_a?(String))
      start_time_param = Chronic.parse(start_time_param)
      raise ArgumentError.new("Start time cannot be parsed" ) unless start_time_param
    end
    
    end_time_param = params[:end_time]
    if(end_time_param.is_a?(String))
      end_time_param = Chronic.parse(end_time_param)
      raise ArgumentError.new("End time cannot be parsed" ) unless end_time_param
    end
    
    new_start = @start_time
    new_start = start_time_param unless start_time_param.nil?
    
    new_end = @end_time
    new_end = end_time_param unless end_time_param.nil?
    
    if(!new_end.nil? && new_start > new_end)
      raise ArgumentError.new('Start date should be lower than the end date')
    end
    
    @all_day = params[:all_day] unless params[:all_day].nil?
    @start_time = new_start
    @end_time = new_end
    
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
    if(date.is_a?(String))
      date = Chronic.parse(date).to_date
    end
    
    start_time.to_date == date || (!end_time.nil? && end_time.to_date == date) 
  end
  def is_for_this_week?()
    daysDifferenceStart = start_time.to_date - Date.today
    daysDifferenceEnd = end_time.to_date - Date.today unless end_time.nil?
    
    return (daysDifferenceStart >= 0 && daysDifferenceStart < 7) || 
           (!end_time.nil? && daysDifferenceEnd >= 0 && daysDifferenceEnd < 7) 
  end
  def matches_regex?(regex)
    # We could simply match to_s, but that would also include the hard coded text and dates
    name =~ regex || (!@location.nil? && @location.matches_regex?(regex))
  end
end