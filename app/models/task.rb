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

	def delete_event
       Task.where(id: params[:task_id]).first.destroy
       render nothing:true
    end

	def self.get_appontments_with_customer(current_staff_id)
		@tasks = self.where(user_id: current_staff_id)
		@tasks.where("customer_id NOT NULL")

	end

	def self.get_data(task_id)
		@test = self.select('customer_id').where(id: task_id)
		@test.first[:customer_id].blank?
	end

	def destroy
      test = Task.where(id: params[:id])
      test.first.update_attributes(customer_id: nil)
      redirect_to profile_users_path
    end

	def self.get_start_date(task_id)
      task = Task.where(id: task_id)
      splits = task.first[:start_date].split
      start = splits[1] + ", " + splits[2]
    end

	def self.get_events_name(task_id)
      event = Task.select('event').where(id: task_id)
      eventname = event.first[:event]
    end

end
