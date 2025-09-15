class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_no
      t.string :email
      t.string :password_digest
      t.string :country
      t.string :state
      t.string :city
      t.timestamps
    end
  end
end
