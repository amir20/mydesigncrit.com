class CreatePage < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :project
      t.string :url
      t.string :title
      t.string :screenshot
      t.string :thumbnail
      t.integer :width
      t.integer :height
      t.boolean :processed, default: false


      t.timestamps
    end

    add_index :pages, :project_id
  end
end
