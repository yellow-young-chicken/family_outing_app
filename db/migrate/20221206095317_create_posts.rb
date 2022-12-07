class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|


      t.integer :spot_id, null: false, default: ""
      t.integer :customer_id, null: false, default: ""
      t.string :title, null: false, default: ""
      t.text :post_content, null: false, default: ""
      t.string :latitude, null: false, default: ""
      t.string :longitude, null: false, default: ""

      t.timestamps
    end
  end
end
