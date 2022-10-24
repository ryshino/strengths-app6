class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  
  def new
  end

  def create
    user = User.find_by(profile: params[:session][:profile])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user_path(user)
    else
      flash.now[:alret] = "入力情報に誤りがあります"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
