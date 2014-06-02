class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :event
      t.string :name
      t.string :start_date
      t.string :end_date

      t.timestamps
    end
  end
end
