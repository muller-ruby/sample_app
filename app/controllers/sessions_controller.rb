class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
     # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみログインできる
     #　authenticateメソッドは認証に失敗した時にfalseを返す(6.3.4)
    if user && user.authenticate(params[:session][:password])
      #　ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      #　ヘルパーメソッドでlog_inを定義したので、上記の通りかける。
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      #　エラーメッセージを作成する
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
