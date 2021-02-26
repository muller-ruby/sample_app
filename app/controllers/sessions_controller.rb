class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみログインできる
    user = User.find_by(email: params[:session][:email].downcase)
     #　authenticateメソッドは認証に失敗した時にfalseを返す(6.3.4)
    if user && user.authenticate(params[:session][:password])
      # ユーザーが有効である場合にのみログインできるようにする。
        if user.activated?
        #　ユーザーログイン後にユーザー情報のページにリダイレクトする
        #　ヘルパーメソッドでlog_inを定義したので、以下の通りかける。
          log_in user
          # # model/user.rbのdef authenticated?(remember_token)実装の関連で
          # #　ログインと連携させた（9.7）
          # remember user
          # paramsハッシュ値を調べれば、送信された値に基づいてユーザーを記憶したり、
          # 忘れたりできるようになる。（三項演算子：if-thenの分岐構造）
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or user
        else
          message = "Account not activated."
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
        end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      #　エラーメッセージを作成する
      render 'new'
    end
  end
  
  def destroy
    # test/integration/users_login_test.rbをした結果、
    # current_userがないために、2回目（user && user.authenticated?(cookies[:remember_token])
    # logged_in?がtrueの場合に限ってlog_outを呼び出すように変更する
    #例：ブラウザで複数のタブで開いていて、1つのタブでログアウトして、もう一つのタブでログアウトしようとするとエラーになる
    log_out if logged_in?
    redirect_to root_url
  end
end
