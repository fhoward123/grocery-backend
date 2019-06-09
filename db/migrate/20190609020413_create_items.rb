class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.text :grocery
      t.text :brand
      t.text :size
      t.integer :quantity
      t.boolean :purchased

      t.timestamps
    end
  end
end
