class CreateRatingsTable < ActiveRecord::Migration
  def change
    create_table "ratings", :force => true do |t|
      t.integer  "product_id"
      t.integer  "user_id"
      t.string   "title"
      t.text     "body"
      t.integer  "stars",      :default => 0
      t.datetime "created_at",                :null => false
      t.datetime "updated_at",                :null => false
    end

    add_index "ratings", ["product_id", "user_id"], :name => "index_ratings_on_product_id_and_user_id", :unique => true
  end
end