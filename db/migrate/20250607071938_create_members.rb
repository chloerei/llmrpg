class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members, id: :uuid do |t|
      t.references :room, null: false, foreign_key: true, type: :uuid, index: false
      t.references :character, null: false, foreign_key: true, type: :uuid

      t.boolean :playing, default: false

      t.timestamps

      t.index [ :room_id, :character_id ], unique: true
    end
  end
end
