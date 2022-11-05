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

  def edit
    @user = User.find(params[:id])
  end
  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
    else
      render 'edit'
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
