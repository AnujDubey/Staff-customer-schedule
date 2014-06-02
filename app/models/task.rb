class Task < ActiveRecord::Base
	# Task-User association
  belongs_to :user
  validates :start_date, presence: { message: "Invalid start date entered" }
  validates :end_date, presence: { message: "is compulsory" }

  attr_accessor :start_minute, :start_hour, :end_minute, :end_hour

  	# Update or set the customer_id with respective task_id.
	def self.set_customer_id(task_id, customer_id)
	    find_taskid = Task.where(:id => task_id)
	    find_taskid.first.update_attributes(customer_id: customer_id)
	end

	# Get all the task(appointments) with respect to current user.
	def self.get_all_appointments(current_user_id)
		 Task.select('id').where(customer_id: current_user_id)
	end

	def self.get_appontments_with_customer(current_staff_id)
		@tasks = self.where(user_id: current_staff_id)
		@tasks.where("customer_id NOT NULL")

	end
	def self.get_data(task_id)
		@test = self.select('customer_id').where(id: task_id)
		@test.first[:customer_id].blank?
	end

end
