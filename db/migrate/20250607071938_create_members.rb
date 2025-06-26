class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.references :room, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.boolean :playing, default: false

      t.timestamps
    end
  end
end
