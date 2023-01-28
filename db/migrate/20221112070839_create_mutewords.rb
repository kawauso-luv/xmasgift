class CreateMutewords < ActiveRecord::Migration[6.1]
  def change
    create_table :mutewords do |t|
      t.integer :user_id
      t.string :muteword
    end
  end
end
