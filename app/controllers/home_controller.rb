require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'news-api'
require 'open-uri'
require 'net/https'

class HomeController < ApplicationController
  before_action :set_breadcrumbs

  # Making instances of all methods within Index so they can be accessed
  def index

    @countryStat = countryApi()

    @weatherIcon = weatherIconApi()
    @weatherTemp = weatherTempApi()
    @weatherTempFeels = weatherTempFeelsApi()
    @weatherHumidity = weatherHumidityApi()
    #@airQuality = airQualityApi()
    @windSpeed = windSpeedApi()
    @topHeadlines = newsApiHeadlines()

    set_cookie()
    show_cookie()

    if !current_user
      reset()
    end

  end

  # Open Weather Api request to return Weather Icon
  def weatherIconApi
    # <--! Openweathermap API database source -->

    # url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    # # url = 'https://api.openweathermap.org/img/w+weather[0]icon+.png'
    # uri = URI(url)
    # response = Net::HTTP.get(uri)
    # output = JSON.parse(response)
    # weatherIcon = output["weather"][0]["icon"]
    # return weatherIcon

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    # url = 'https://api.openweathermap.org/img/w+weather[0]icon+.png'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response, object_class: OpenStruct)
    @weatherIcon = @output["weather"][0]["icon"]
    return @weatherIcon

    # # img_file = "my_img.jpg"
    # img_url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    # url = URI.parse(img_url)
    # # file = open(img_file)
    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = (url.scheme == 'https')
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # request = Net::HTTP::Post.new(url.path + '?' + url.query)
    # # request.body = Base64.encode64(file.read)
    # request["Content-Type"] = "text/plain"
    # response = http.request(request)
    #
    # output = JSON.parse(response, object_class: OpenStruct)
    # weatherIcon = output["weather"][0]["icon"]
    # return weatherIcon
    # # response.code
    # # response.body
    # # file.close

  end

  # Rapid API request to return Covid statistics
  def countryApi
    # <--! Rapid API database source -->

    url = URI("https://covid-193.p.rapidapi.com/statistics")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'covid-193.p.rapidapi.com'
    request["x-rapidapi-key"] = '4a676d2b21msh5dd238b250b6e52p1ef36bjsncafc3a26696d'

    @response = http.request(request)
    @data = JSON.parse(@response.body)
    @sortedData = @data["response"].sort_by { |hash| hash["cases"]["total"] }.reverse
    return @sortedData

  end

  # Open Weather API request to return Temperature
  def weatherTempApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @weatherTemp = @output["main"]["temp"]
    return @weatherTemp

  end

  # Open Weather API request to return Temperature feels
  def weatherTempFeelsApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @weatherTempFeels = @output["main"]["feels_like"]
    return @weatherTempFeels

  end

  # Open Weather API request to return Humidity
  def weatherHumidityApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @weatherHumidity = @output["main"]["humidity"]
    return @weatherHumidity

  end

  # Weatherbit API request to return Air Quality
  # def airQualityApi
  #   # <--! Weatherbit API database source -->
  #
  #   @url = 'https://api.weatherbit.io/v2.0/current/airquality?lat=53.350140&lon=-6.266155&key=57098542035e46808c46307b45c66c5b'
  #   @uri = URI(@url)
  #   @response = Net::HTTP.get(@uri)
  #   @output = JSON.parse(@response)
  #   @airQuality = @output["data"][0]["aqi"]
  #   return @airQuality
  #
  # end

  # # Weatherbit API request to return Wind Speed
  # def windSpeedApi
  #   # <--! Weatherbit API database source -->
  #
  #   @url = 'https://api.weatherbit.io/v2.0/current?lat=53.350140&lon=-6.266155&key=57098542035e46808c46307b45c66c5b'
  #   @uri = URI(@url)
  #   @response = Net::HTTP.get(@uri)
  #   @output = JSON.parse(@response)
  #   @windSpeed = @output["data"][0]["wind_spd"]
  #   @windSpeedKm = (@windSpeed * 3600)/1000
  #   return @windSpeedKm.round(2)
  #
  # end

  # Open Weatherbit API request to return Wind Speed
  def windSpeedApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @windSpeed = @output["wind"]["speed"]
    @windSpeedKm = (@windSpeed * 3600)/1000
    return @windSpeedKm.round(2)

  end

  # NewsApi request for top headlines with Irish sources
  def newsApiHeadlines

    newsApi = News.new("7946b0d0be48492cb30e8769dfaa1ac1")
    headlines = newsApi.get_top_headlines(country: 'us')

  end
#============================================================#

  # Reset breadcrumbs
  def reset
      reset_session
      @breadcrumbs = nil
  end

  # Set cookie to be current user's name
  def set_cookie
    if current_user
      cookies[:user_name] = current_user.name
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
