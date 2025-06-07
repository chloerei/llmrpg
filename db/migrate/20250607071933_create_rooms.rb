class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.references :persona, null: true, foreign_key: true

      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
