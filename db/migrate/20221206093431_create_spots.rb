class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      
      t.string :spot_name, null: false, default: ""
      
      t.timestamps
    end
  end
end
