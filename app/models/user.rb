class User < ActiveRecord::Base
	has_many :pointmaps
	acts_as_authentic
end
