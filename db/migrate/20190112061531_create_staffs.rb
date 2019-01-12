class CreateStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :role
      t.integer :salary
      t.integer :reporter_id

      t.timestamps
    end
  end
end
