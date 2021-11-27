require 'news-api'
require 'open-uri'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'
require 'ostruct'
# require 'open-weather-api'

class HomeController < ApplicationController
  before_action :set_breadcrumbs

  # Making instances of all methods within Index so they can be accessed
  def index

    @topHeadlines = newsApiHeadlines()
    # @weather = weatherApi()
    @countryStat = countryApi()

    set_cookie()
    show_cookie()

    if !current_user
      reset()
    end

  end

  # NewsApi request for top headlines with Irish sources
  def newsApiHeadlines

    newsApi = News.new("7946b0d0be48492cb30e8769dfaa1ac1")
    headlines = newsApi.get_top_headlines(country: 'ie')

  end

  # Open Weather Api request to return temperature
  # def weatherApi
  #
  #   options = { units: "metric", APPID: "364958621b0f8ab723ee422e4a119aa4" }
  #   request = OpenWeatherAPI::Current.city("Dublin, IE", options)
  #
  #   temp = request['main']['temp']
  #
  # end
  
  def countryApi
  #   # url = 'https://covid-193.p.rapidapi.com/statistics'
	# 	# @covidResponse = HttpLucas.get(url, {}, {
	# 	# 	'Content-Type' => 'application/json',
	# 	# 	'x-rapidapi-key' => '4a676d2b21msh5dd238b250b6e52p1ef36bjsncafc3a26696d',
	# 	# 	'x-rapidapi-host' => 'covid-193.p.rapidapi.com'
	# 	# })
  #   #
	# 	# @covidData = JSON.parse(@covidResponse.body)
	# 	# @sortedCovidData = @covidData["response"].sort_by { |hash| hash["cases"]["total"] }.reverse
  #   #
  #   # return @sortedCovidData
  #   #=====================#

    url = URI("https://covid-193.p.rapidapi.com/statistics")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'covid-193.p.rapidapi.com'
    request["x-rapidapi-key"] = '4a676d2b21msh5dd238b250b6e52p1ef36bjsncafc3a26696d'

    @response = http.request(request)
    #puts response.read_body
    @data = JSON.parse(@response.body)
    @sortedData = @data["response"].sort_by { |hash| hash["cases"]["total"] }.reverse
    return @sortedData
  end

  # Reset breadcrumbs
  def reset
      reset_session
      @breadcrumbs = nil
  end

  # Set cookie to be current user's name
  def set_cookie
    if current_user
      cookies[:user_name] = current_user.name
    # elsif current_editor
    #   cookies[:user_name] = current_editor.name
    else
      cookies[:user_name] = nil
    end
  end

  # Show the cookie
  def show_cookie
    @user_name = cookies[:user_name]
  end

  # Set breadcrumb to be last visited URL
  private
  def set_breadcrumbs
    if session[:breadcrumbs]
      @breadcrumbs = session[:breadcrumbs]
    else
      @breadcrumbs = Array.new
    end

    @breadcrumbs.push(request.base_url)

    if @breadcrumbs.count > 1
      @breadcrumbs.shift
    end

    session[:breadcrumbs] = @breadcrumbs

  end

end
