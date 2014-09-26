class AddPrivateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :private, :boolean, default: true, null: false
  end
end
