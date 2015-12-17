class WelcomeController < ApplicationController
  def index
  	@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NB KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC)
  	@states.sort!
  	@locations = Location.all

  	if params[:city] != nil
  		city = params[:city]
  		if city.include? " "
  			city.gsub!(" ","_")
  		end

  		if Location.where(city: city, state: params[:state]) == nil
	  		new_location = Location.new
	  		new_location.city = city
	  		new_location.state = params[:state]
	  		new_location.save
  		end

		response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")
	  	@location = response['location']['city']
	  	@temp_f = response['current_observation']['temp_f']
	  	@temp_c = response['current_observation']['temp_c']
	  	@weather_icon = response['current_observation']['icon_url']
	  	@weather_words = response['current_observation']['weather'] 
	  	@forecast_link = response['current_observation']['forecast_url']
	  	@real_feel = response['current_observation']['feelslike_f']
	 end
   end


  def test
  	 response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/GA/Atlanta.json")
  	
	  	@location = response['location']['city']
	  	@temp_f = response['current_observation']['temp_f']
	  	@temp_c = response['current_observation']['temp_c']
	  	@weather_icon = response['current_observation']['icon_url']
	  	@weather_words = response['current_observation']['weather'] 
	  	@forecast_link = response['current_observation']['forecast_url']
	  	@real_feel = response['current_observation']['feelslike_f']
  end

end