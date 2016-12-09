class SessionsController < ApplicationController
	skip_before_filter :authorize
  def new
  end

  def create
  	#如果验证成功返回用户对象并将用户对象id保存到session中
  	if user = User.authenticate(params[:name], params[:password])
  		session[:user_id] = user.id
        redirect_to admin_url
    else
    	redirect_to login_url, :alert => "用户不存在或密码错误"
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to store_url, :notice => "已注销"
  end
end
