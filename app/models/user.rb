class User < ActiveRecord::Base
  # User-task association
	belongs_to :role
  has_many :appointments, :class_name => 'Task', :foreign_key => 'customer_id'
  has_many :tasks, :class_name => 'Task', :foreign_key => 'user_id'

  # Include default devise modules.
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :firstname, presence: { message: "is compulsory" }
  validates :lastname, presence: { message: " is compulsory" }

  # Get the random password for the staff when staff is not active.
  ENCODE_CHARS = [*?a..?z, *?A..?Z]
  def get_random_password(n)
    6.times.map { |i|
      n, mod = n.divmod(ENCODE_CHARS.size)
      ENCODE_CHARS[mod]
    }.join

  end

  # Validate password to save after staff confirmation. 
  def validate_password? 
     self.new_record? && self.staff?
  end

  # Check Role Type 
  def has_role?( user_role )
     self.role.role_type == user_role
  end

  # Check for Empty Role Type
  def has_role_blank?( user_role )
      self.role_id.blank?
  end

  # Set Role Type to User
  def set_user_role(role)
    role_id = Role.where(role_type: role).first.id
    self.update_attributes(role_id: role_id) 
  end

  # Check for Admin Role Type
  def admin?
    self.role.role_type == "admin"
  end

  # Check for Staff Role Type
  def staff?
    self.role.role_type == "staff"
  end

  # Check for Customer Role Type
  def customer?
    self.role.role_type == "customer"
  end

  # Return Some particular(id, firstname, lastname, email, confirmed_at) fields of all staffs
  def self.get_all_staffs
    staff_id = Role.where(role_type: "staff").first.id
    User.select('id','firstname','lastname','email', 'confirmed_at').where(role_id: staff_id) 
  end

  # Return Some fields(id, firstname, lastname, email) of all customers
  def self.get_all_customers
    customer_id = Role.where(role_type: "customer").first.id
    User.select('id','firstname','lastname','email').where(role_id: customer_id) 
  end

  def self.staffs_name_from_user(user_id)
      uid = @assigned.first[:user_id]
      @name = User.select('firstname', 'lastname').where(id: uid)
      @name.first[:firstname] + " " + @name.first[:lastname]
  end

  def self.get_customers_name(user_id)
      name = User.select('firstname', 'lastname').where(id: user_id)
      customer_name = name.first[:firstname].to_s + " ".to_s + name.first[:lastname].to_s
  end

  # Update staff password after the signup confirmation.
  def update_staffs_password(password, password_confirmation)
     self.update_attributes(password:  password, password_confirmation:  password_confirmation)
  end

   protected

     def confirmation_required?
     	true
     end

end
