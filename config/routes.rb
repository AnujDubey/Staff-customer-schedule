Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  
   devise_scope :user do
    root :to => 'devise/sessions#new'
   end

   resources :users,except: [:update, :index] do
      collection do
        get :profile
        post :post_task
        post :fix_meeting
        get :staffs_profile
        get :staff_signup
        patch :staff_create
        post :save_monthly_task
        post :staff_post_task
        post :save_task
        post :delete_event
      end
   end
   
  resources :admins do
    collection do 
      get :profile
      get :show_staffs
      get :show_customers
  	end
  
  	member do
  		# get :show
  	end

  end

end
