module SessionsHelper
  #　渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザを返す（いる場合）.8.2.2参照
  def current_user
    if session[:user_id]
      #　Userオブジェクトそのものの論理値は常にtrueになる。
      #　そのおかげで、@current_userに何も代入されていないときだけ
      #　find_by呼び出しが実行され、無駄なデータベースへの読み出しが
      #　行われなくなる。（||＝は、or equals)
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  # ユーザーがログインしていればtrue,その他ならfalseを返す
  def logged_in?
    #　current_userがnilではないという状態。否定演算子「！」が必要。8.18
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
