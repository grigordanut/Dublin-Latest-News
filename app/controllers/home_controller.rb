require 'news-api'
require 'open-uri'
# require 'open_weather'

class HomeController < ApplicationController
  before_action :set_breadcrumbs

  # Making instances of all methods within Index so they can be accessed
  def index

    @topHeadlines = newsApiHeadlines()
    #@weather = weatherApiNew()

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

  # # Open Weather Api request to return temperature
  # def weatherApiNew
  #
  #   options = { units: "metric", APPID: "364958621b0f8ab723ee422e4a119aa4" }
  #   request = OpenWeatherAPI::Current.city("Dublin, IE", options)
  #
  #   temp = request['main']['temp']
  #
  # end

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
