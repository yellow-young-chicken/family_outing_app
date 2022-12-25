class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|


      t.integer :spot_id, null: false
      t.integer :customer_id, null: false
      t.string :title, null: false, default: ""
      t.text :post_content, null: false
      t.string :latitude, default: "", null: false
      t.string :longitude, default: "", null: false
      t.string :address, default: ""
      t.float :rate, null: false, default: 0

      t.timestamps
    end
  end
end
