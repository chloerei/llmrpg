class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    enable_extension "citext"

    create_table :users do |t|
      t.citext :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
