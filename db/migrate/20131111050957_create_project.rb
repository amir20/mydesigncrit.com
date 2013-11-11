class CreateProject < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user
      t.string :title
      t.string :thumbnail

      t.timestamps
    end

    add_index :projects, :user_id
  end
end
