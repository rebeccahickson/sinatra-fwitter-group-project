class UsersController < ApplicationController


  get '/signup' do
    if logged_in?
      redirect '/tweets'
    end
    erb :'/users/new'
  end

  post '/signup' do
    u = User.new(username: params["username"], email: params["email"], password: params["password"])
    if u.username.blank? || u.password.blank? || u.email.blank? || User.find_by_username(params["username"])
           redirect '/signup'
        else
            u.save
            session[:user_id] = u.id
            redirect '/tweets'
        end
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    end
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by_username(params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/tweets'
        else
            redirect '/signup'
        end
  end

    get '/logout' do
        if logged_in?
            session.destroy
            redirect to '/login'
        else
            redirect to '/'
        end
    end

    get '/users/:slug' do
        @user = User.all.find{|user| user.slug == params[:slug]}
        erb :'/users/show'
    end

end
