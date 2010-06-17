class User < ActiveRecord::Base
	has_many :blasts
	acts_as_authentic
end
