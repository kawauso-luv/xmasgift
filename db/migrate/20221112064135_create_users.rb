class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :twitter_id
      t.string :name
      t.text :bio
      t.string :mail
      t.string :password_digest
      t.timestamps null: false
    end
  end
end
