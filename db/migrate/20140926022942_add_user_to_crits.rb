class AddUserToCrits < ActiveRecord::Migration
  def change
    add_reference :crits, :user, index: true
  end
end
