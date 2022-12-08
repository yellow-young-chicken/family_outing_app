class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|

      t.integer :spot_name, null: false, default: 0

      t.timestamps
    end
  end
end
