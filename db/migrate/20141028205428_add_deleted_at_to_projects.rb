class AddDeletedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deleted_at, :datetime
    add_index :projects, :deleted_at

    add_column :pages, :deleted_at, :datetime
    add_index :pages, :deleted_at

    add_column :crits, :deleted_at, :datetime
    add_index :crits, :deleted_at
  end
end
