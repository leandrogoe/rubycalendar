class Location
  def initialize(params)
    raise ArgumentError.new("Parameter name is required" ) unless params[:name]
      
    update(params)
  end
  def update(params)
    @name = params[:name]
    @address = params[:address]
    @city = params[:city]
    @state = params[:state]
    @zip = params[:zip]
  end
  def to_s
    desc_array = [@name, @address, @city, @state, @zip].reject { |s| s.to_s.empty? }
    desc_array.join(", ")
  end
end