class CreateAppUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :app_users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
