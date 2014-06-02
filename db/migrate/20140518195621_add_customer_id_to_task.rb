class AddCustomerIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :customer_id, :integer
  end
end
