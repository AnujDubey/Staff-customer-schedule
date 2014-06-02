class AdminsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_valid_autherization 
    
	def profile
		@admin = current_user
		@time = @admin[:last_sign_in_at].strftime('%I:%M:%S %p')
		@date = @admin[:last_sign_in_at].strftime('%d/%m/%y')
	end

	# Check the valid autherization for users
	def check_valid_autherization 
		redirect_to profile_users_path and return  if current_user.has_role?('customer')
		redirect_to staffs_profile_users_path and return  if current_user.has_role?('staff')
		 
	end

	def show_staffs
		@staffs = User.get_all_staffs
		respond_to do |format|
			format.html
			format.js
		end
	end

	def show_customers
		@customers = User.get_all_customers
		respond_to do |format|
			format.js
		end
	end

	def destroy
		user_id = User.where(id: params[:id])
		if user_id.first.has_role?('staff') == true
			@test = true
		else
			@test = false
		end
		User.where(id: params[:id]).first.delete
		@staffs = User.get_all_staffs
		@customers = User.get_all_customers
		respond_to do |format|
			format.js
		end
		# User.where(id: params[:id]).first.delete
		# redirect_to profile_admins_path
	end

end