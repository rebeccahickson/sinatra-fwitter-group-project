require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  helpers do  #allows our views to access these methods
    def logged_in?
      !!current_user
    end

    def current_user   #memoization
      @current_user ||=  User.find(session[:user_id]) if session[:user_id]
    end
  end

    private
  def redirect_if_not_logged_in
    if !logged_in?
      redirect '/login'
    end
  end

end
