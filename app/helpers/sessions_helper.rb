module SessionsHelper
  #　渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #　ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 記憶トークンcookiesに対応するユーザーを返す
  def current_user
        # （ユーザーidにユーザーidのセッションを代入した結果）
        # ユーザーIDのセッションが存在すれば（9.9）
        # 「＝」は比較ではなく、代入を行っている。
    if(user_id = session[:user_id])
        #　Userオブジェクトそのものの論理値は常にtrueになる。
        #　そのおかげで、@current_userに何も代入されていないときだけ
        #　find_by呼び出しが実行され、無駄なデータベースへの読み出しが
        #　行われなくなる。（||＝は、or equals)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #raise   # テストがパスすれば、この部分がテストされていないことがわかる
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 現在ログイン中のユーザを返す（いる場合）.8.2.2参照
  # def current_user
  #   if session[:user_id]
  #  
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end
 
  
  # ユーザーがログインしていればtrue,その他ならfalseを返す
  def logged_in?
    #　current_userがnilではないという状態。否定演算子「！」が必要。8.18
    !current_user.nil?
  end
  
   
  # 永続的にセッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したurl（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたurlを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
