require 'location'
require 'chronic'

class Event
  attr_accessor :start_time, :end_time, :name
  
  def initialize(name, params)
    raise ArgumentError.new("Parameter name is required" ) unless name
    raise ArgumentError.new("Parameter start_time is required" ) unless params[:start_time]
    raise ArgumentError.new("You must either supply end_time or set all_day to true") unless params[:end_time] || params[:all_day]
    
    @name = name
    @all_day = false
    update_event(params)
  end
  def update_event(params)
    @all_day = params[:all_day] unless params[:all_day].nil?
    
    if(!params[:start_time].nil?)
      @start_time = params[:start_time]  
      if(@start_time.is_a?(String))
        @start_time = Chronic.parse(@start_time)
      end
    end
    
    if(!params[:end_time].nil?)
      @end_time = params[:end_time]
      if(@end_time.is_a?(String))
        @end_time = Chronic.parse(@end_time)
      end
    end
    
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