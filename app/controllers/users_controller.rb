class UsersController < ApplicationController
  # beforeフィルターはコントローラー内の全てのアクションに適用される
  # :onlyオプション（ハッシュ）を渡すことで、:editと:updateアクションだけ
  # にこのフィルタが適用されるよう制限をかけた。
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # 別のユーザーのプロフィールを編集したい。リダイレクトさせたい（10.25）
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
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
      # log_in @user
      # # ユーザ登録が終わってからユーザーに手動ログインを促すと、
      # #　ユーザーに余分な手間を強いることになるので、ユーザー登録中
      # #　にログインするには、Usersコントローラーのcreateアクションにlog_in
      # # を追加する
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      #UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    # user_paramsを使うことでStrong Parametersを使って、マスアサインメントの脆弱性を防止している
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  # def index
  #   @users = User.all
  # end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeアクションを追加（10.15）
    
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
