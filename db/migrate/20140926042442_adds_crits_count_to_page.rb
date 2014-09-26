class AddsCritsCountToPage < ActiveRecord::Migration
  def change
    add_column :pages, :crits_count, :integer, default: 0, null: false
    add_column :projects, :pages_count, :integer, default: 0, null: false
    add_column :projects, :crits_count, :integer, default: 0, null: false
  end
end
