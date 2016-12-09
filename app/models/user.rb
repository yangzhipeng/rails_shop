require 'digest/sha2'

class User < ActiveRecord::Base
	before_destroy :ensure_an_admin_remains

	validates :name, :presence => true, :uniqueness => true, :length => {:in => 4..20}
	validates :password, :confirmation => true
	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    #validates :email, presence: true, :uniqueness => true, format: { with: VALID_EMAIL_REGEX }
	attr_accessor :password_confirmation
	attr_reader :password

	validate :password_must_be_present

    def User.encrypt_password(password,salt)
    	Digest::SHA2.hexdigest(password + "wibble" + salt)
    end

    def password=(password)
    	@password = password

    	if password.present?
    		generate_salt
    		self.hashed_password = self.class.encrypt_password(password,salt)
    	end
    end

    def User.authenticate(name,password)
    	#根据用户名查找存在数据库的用户
    	if user = find_by_name(name)
    		#用户输入的密码和salt值加密与保存在数据库的hash密码匹配，成功则返回用户对象
    		if user.hashed_password == encrypt_password(password,user.salt)
    			user
    		end
    	end
    end

    def ensure_an_admin_remains
    	if User.count <= 1
    		raise "不能删除最后一个管理员"
    	end
    end

	private
	def password_must_be_present
		errors.add(:password,"Missing password") unless hashed_password.present?
	end

	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end
end
