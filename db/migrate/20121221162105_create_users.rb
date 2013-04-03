class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :mobile_phone
      t.string :crypted_password
      t.string :password_salt
      t.string :session_id
      t.string :persistence_token
      t.integer :login_count
      t.string :last_request_at
      t.string :current_login_at
      t.string :last_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.text :user_attributes
      t.datetime :refreshed_at

      t.timestamps
    end
  end
end
