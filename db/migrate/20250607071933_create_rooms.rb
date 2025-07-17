class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.string :name, null: false
      t.text :prompt

      t.timestamps
    end
  end
end
