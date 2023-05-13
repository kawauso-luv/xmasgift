class CreatePresents < ActiveRecord::Migration[6.1]
  def change
    create_table :presents do |t|
      t.integer :sendfrom_id
      t.integer :sendto_id
      t.text :content
    end
  end
end
