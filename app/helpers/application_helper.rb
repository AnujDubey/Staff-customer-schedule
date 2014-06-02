# Helper module for the Application
module ApplicationHelper
	def signed_in(resource_or_scope)
		redirect_to 'home#index'
	end

	def get_year(date)
    Time.parse(date).year
	end

	def get_month(date)
		Time.parse(date).month
	end

	def get_day(date)
		Time.parse(date).day
	end

	def get_hour(date)
		Time.parse(date).hour
	end

	def get_minute(date)
		Time.parse(date).min
	end
	
end
