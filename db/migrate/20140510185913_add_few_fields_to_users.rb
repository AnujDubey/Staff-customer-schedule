class AddFewFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :employee_id, :string
    add_column :users, :role_id, :integer
  end
end
