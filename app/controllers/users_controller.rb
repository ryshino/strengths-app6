class UsersController < ApplicationController
  before_action :require_login, only: [:show, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:notice] = "ユーザー登録に成功しました"
      redirect_to user_path(@user)
    else
      flash.now[:alret] = "入力情報に誤りがあります"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    current_user.destroy
    redirect_to new_user_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :profile, :password, :password_confirmation)
    end
end
