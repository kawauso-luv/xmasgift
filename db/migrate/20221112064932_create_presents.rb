class CreatePresents < ActiveRecord::Migration[6.1]
  def change
    create_table :presents do |t|
      t.string :sendto
      t.text :content
    end
  end
end
