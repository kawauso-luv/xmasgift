class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :twitter_id
      t.string :name
      t.text :bio
    end
  end
end
