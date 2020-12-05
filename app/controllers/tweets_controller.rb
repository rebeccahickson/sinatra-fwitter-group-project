class TweetsController < ApplicationController
    get '/tweets' do
        redirect_if_not_logged_in
        erb :'/tweets/index'
    end

    get '/tweets/new' do
        redirect_if_not_logged_in
        erb :'/tweets/new'
    end

    post '/tweets' do
        if params[:content].blank?
            redirect '/tweets/new'
        end
        @tweet = Tweet.new
        @tweet.content = params[:content]
        current_user.tweets << @tweet
        @tweet.save
    end

    get '/tweets/:id' do
        @tweet = Tweet.all.find{|tweet| tweet.id.to_s == params[:id]}
        erb :'/tweets/show'
    end

    get '/tweets/:id/edit' do
        @tweet = Tweet.all.find{|tweet| tweet.id.to_s == params[:id]}
        erb :'/tweets/edit'
    end

    patch '/tweets/:id' do
        if logged_in?
            if params[:content].blank?
                redirect "/tweets/#{params[:id]}/edit"
            else
                @tweet = Tweet.find_by_id(params[:id])
                if @tweet && @tweet.user == current_user
                    if @tweet.update(content: params[:content])
                        redirect "/tweets/#{@tweet.id}"
                    else
                        redirect "/tweets/#{@tweet.id}/edit"
                    end
                else
                redirect "/tweets"
                end
            end
        else
        redirect "/login"
        end
    end

    delete '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user == current_user
                @tweet.delete
            end
        redirect to '/tweets'
        else
            redirect to '/login'
        end
    end




    private
  def redirect_if_not_logged_in
    if !logged_in?
      redirect '/login'
    end
  end

end
