class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #　Railsの全てのコントローラーの親クラスであるApplicationコントローラーに
  #　Railsのセッション用ヘルパーモジュールを読み込ませれば、どのコントローラー
  #　にも浸かるようになる。（8）
  include SessionsHelper
  
  # def hello
  #   render html: "hello, world"
  # end
  
  
end