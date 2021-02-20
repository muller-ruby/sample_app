class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #　保存の成功をここで扱う
      log_in @user
      # ユーザ登録が終わってからユーザーに手動ログインを促すと、
      #　ユーザーに余分な手間を強いることになるので、ユーザー登録中
      #　にログインするには、Usersコントローラーのcreateアクションにlog_in
      # を追加する
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  # def index
  #   @users = User.all
  # end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
