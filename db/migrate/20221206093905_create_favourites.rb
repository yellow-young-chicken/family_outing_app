class CreateFavourites < ActiveRecord::Migration[6.1]
  def change
    create_table :favourites do |t|

      t.integer :customer_id, null: false, default: ""
      t.integer :post_id, null: false, default: ""

      t.timestamps
    end
  end
end
