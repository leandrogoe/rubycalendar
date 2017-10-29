class Location
  attr_accessor :name, :address, :city, :state, :zip
  def initialize(params)
    raise ArgumentError.new("Parameter name is required" ) unless params[:name]
      
    update(params)
  end
  def update(params)
    @name = params[:name] unless params[:name].nil?
    @address = params[:address] unless params[:address].nil?
    @city = params[:city] unless params[:city].nil?
    @state = params[:state] unless params[:state].nil?
    @zip = params[:zip] unless params[:zip].nil?
  end
  def to_s
    desc_array = [@name, @address, @city, @state, @zip].reject { |s| s.to_s.empty? }
    desc_array.join(", ")
  end
  def matches_regex?(regex)
    to_s =~ regex
  end
end