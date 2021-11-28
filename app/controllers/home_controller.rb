require 'uri'
require 'net/http'
require 'openssl'

require 'json'
require 'news-api'
# require 'open-uri'
class HomeController < ApplicationController
  before_action :set_breadcrumbs

  # Making instances of all methods within Index so they can be accessed
  def index

    @countryStat = countryApi()

    @weatherIcon = weatherIconApi()
    @weatherTemp = weatherTempApi()
    @weatherTempFeelsApi = weatherTempFeelsApi()
    @weatherHumidity = weatherHumidityApi()
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

    url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    # url = 'https://openweathermap.org/img/w/10n.png'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    output = JSON.parse(response)
    weatherIcon = output["weather"][0]["icon"]
    return weatherIcon

  end

  # Open Weather Api request to return temperature
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

  # Open Weather Api request to return Temperature
  def weatherTempApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @weatherTemp = @output["main"]["temp"]
    return @weatherTemp

  end

  # Open Weather Api request to return Temperature Feels
  def weatherTempFeelsApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @weatherTempFeels = @output["main"]["feels_like"]
    return @weatherTempFeels

  end

  # Open Weather Api request to return Humidity
  def weatherHumidityApi
    # <--! Openweathermap API database source -->

    @url = 'http://api.openweathermap.org/data/2.5/weather?q=Dublin,ie&units=metric&appid=364958621b0f8ab723ee422e4a119aa4'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    @weatherHumidity = @output["main"]["humidity"]
    return @weatherHumidity

  end

  # NewsApi request for top headlines with Irish sources
  def newsApiHeadlines

    newsApi = News.new("7946b0d0be48492cb30e8769dfaa1ac1")
    headlines = newsApi.get_top_headlines(country: 'ie')

  end
#============================================================

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
