class ActiveSupport::TestCase

	def login_as(user)
		session[:user_id] = user(user).id
	end

	def logout
		session.delete :user_id
	end

	def setup
		login_as :one if defined? session
	end
end