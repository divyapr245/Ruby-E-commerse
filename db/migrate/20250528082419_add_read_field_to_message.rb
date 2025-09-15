class AddReadFieldToMessage < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :read, :boolean, default: false
  end
end
