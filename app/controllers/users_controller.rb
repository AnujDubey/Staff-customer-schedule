class UsersController < ApplicationController
  	# before_filter :check_valid_autherization
    # Include ApplicationHelper for some Helper methods like date-time etc.
    include ApplicationHelper

    def new
      @staff = User.new
      session[:role_id] = Role.where(role_type: "staff").first.id
      @names = User.first[:firstname]
    end

    def create
      binding.pry
      @staff = User.new(staff_params) 
      @staff.role_id = session[:role_id]  
      @staff.password = @staff.get_random_password(22) 
      if @staff.save 
        session.delete(:role_id)
        redirect_to show_staffs_admins_path
      else 
        render :new
      end 
    end

    def save_monthly_task
      if params[:task][:event].blank?
        @task = Task.create(event: params[:task][:event])
       else
        @task = Task.new
        start_time = params[:start_year].split
        start_time[4] = params[:task][:start_hour].to_s + ":" + params[:task][:start_minute].to_s + ":00"
        start_time = start_time.join(' ')
        end_time = params[:end_year].split
        end_time[4] = params[:task][:end_hour].to_s + ":" + params[:task][:end_minute].to_s + ":00"
        end_time = end_time.join(' ')

        if current_user.has_role?("staff")
          @task.user_id = current_user.id
          @task.event = params[:task][:event]
          @task.name = "month"
          @task.start_date = start_time
          @task.end_date = end_time
          @task.save
        end

      end

       respond_to  do |format|
         format.js
       end
    end

    def save_task
      @task = Task.new
         if current_user.has_role?("staff")
          @task.user_id = current_user.id
          @task.event = params[:title]
          @task.name = params[:name]
          @task.start_date = params[:start_date]
          @task.end_date = params[:end_date]
          @task.save unless params[:title].blank?
         end
      render text: "done"
    end

    def profile
    	@user = current_user
    	@tasks = [Time.now,2.hours.from_now]
    	@date = params[:month] ? Date.parse(params[:month]) : Date.today
      @staffs = User.get_all_staffs
      @my_staffs = @staffs.collect {|t| [t.firstname+" "+t.lastname, t.id] }
      @my_appointments = Task.get_all_appointments(current_user[:id])
      @staffs_name_for_appointment = @my_appointments. map{|t| {id: t.id, staff_name: User.get_staffs_name(t.id)}}
      @Events = @my_appointments. map{|i| {event_name: Task.get_events_name(i.id)}}
      @start_day = @my_appointments. map { |t| {start: Task.get_start_date(t.id)}}
      @last_time = @user[:last_sign_in_at].strftime('%I:%M:%S %p')
      @last_date = @user[:last_sign_in_at].strftime('%d/%m/%y')
    end

    def staffs_profile
      @user = current_user
      @event = Task.new
      @my_appointments = Task.get_appontments_with_customer(current_user[:id])
      @customers_name_for_appointment = @my_appointments.map{ |t| { customers_name: User.get_customers_name(t.customer_id)}}
      @Events = @my_appointments. map{|i| {event_name: Task.get_events_name(i.id)}}
      @start_day = @my_appointments. map { |t| {start: Task.get_start_date(t.id)}}
      @time = @user[:last_sign_in_at].strftime('%I:%M:%S %p')
      @date = @user[:last_sign_in_at].strftime('%d/%m/%y')
    end

    def staff_create 
      email_id = params[:user][:email]
      @staff = User.where(email: email_id).first
      if @staff.update_staffs_password(params[:user][:password], params[:user][:password_confirmation])
        sign_in  @staff
        redirect_to staffs_profile_users_path
      else
        render :staff_signup
      end
    end

    def staff_signup
      if params[:id].present?
        @staff = User.select('id, firstname, lastname, email').where(id: params[:id]).first 
        @staff[:role_id] = session[:role_id]
      end
    end

    def post_task
      
    end

    def post_staff_task
      tasks =  current_user.tasks.map{|t| {title: t.event, start: t.start_date, end: t.end_date}}
      render json: tasks.to_json
    end
    # Sending the Task data to Staff.js in form of json
    def staff_post_task
      staff =  params[:user_id].present? ? User.where(:id => params[:user_id]).first : current_user
      tasks =  staff.tasks.map{|t| {
        id: t.id, 
        title: t.event, 
        start_year: get_year(t.start_date),
        start_month: get_month(t.start_date) - 1,
        start_day: get_day(t.start_date),
        start_hour: get_hour(t.start_date),
        start_minute: get_minute(t.start_date),
        end_year: get_year(t.end_date),
        end_month: get_month(t.end_date) - 1,
        end_day: get_day(t.end_date),
        end_hour: get_hour(t.end_date),
        end_minute:  get_minute(t.end_date)
      }}
      render json: tasks.to_json
     end

    # Post the meeting data to user.js
    def fix_meeting
      @meetings = Task.get_data(params[:task_id])
      if @meetings == true
        @appointment = Task.set_customer_id(params[:task_id].to_i, current_user[:id])
        @assigned=Task.where(customer_id: current_user[:id])
        tasks =  @assigned.map{|t| {
          user_id: t.user_id, 
          staff_name: staffs_name_from_user(t.user_id),
          title: t.event, 
          customer_id: t.customer_id,
          start_year: get_year(t.start_date),
          start_month: get_month(t.start_date) - 1,
          start_day: get_day(t.start_date),
          start_hour: get_hour(t.start_date),
          start_minute: get_minute(t.start_date),
          end_year: get_year(t.end_date),
          end_month: get_month(t.end_date) - 1,
          end_day: get_day(t.end_date),
          end_hour: get_hour(t.end_date),
          end_minute:  get_minute(t.end_date)
        }}
      render json: tasks.to_json

      else
        tasks = {user_id: 125555}
        render json: tasks.to_json
         # respond_to  do |format|
         # format.html
         # format.js
       end

    end

    def get_staffs_name(task_id)
      uid = Task.select('user_id').where(id: task_id).first
      staff_id=uid[:user_id]
      name = User.select('firstname', 'lastname').where(id: staff_id)
      staff_name = name.first[:firstname].to_s.capitalize + " ".to_s + name.first[:lastname].to_s.capitalize
    end

    

    

    def calculate_time start_date
      start = start_date
      dummy_array = []
      dummy_array = start.split
      dummy_array[3].to_s + "-" + 05.to_s + "-" + dummy_array[2].to_s + " " + dummy_array[4].to_s
    end

    # Check for the valid User
    def check_valid_autherization 
  		redirect_to profile_admins_path and return  if current_user.has_role?('admins')
  		redirect_to staffs_profile_users_path and return  if current_user.has_role?('staff')
  		 
  	end

    private

    def staff_params
      params.require(:user).permit(:firstname, :lastname, :email, :role_id)
    end

end