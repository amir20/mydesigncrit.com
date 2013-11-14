class CreateCrit < ActiveRecord::Migration
  def change
    create_table :crits do |t|
      t.references :page
      t.text :comment
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.integer :order

      t.timestamps
    end

    add_index :crits, :page_id
  end
end
