class Role < ActiveRecord::Base
	# Role-User Association
	has_many :users, dependent: :destroy 
end
