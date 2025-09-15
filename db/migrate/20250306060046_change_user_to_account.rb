class ChangeUserToAccount < ActiveRecord::Migration[8.0]
  def change
    rename_table :users, :accounts
  end
end
