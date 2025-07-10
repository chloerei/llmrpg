class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.references :conversation, null: false, foreign_key: true, type: :uuid
      t.references :character, type: :uuid

      t.integer :role, null: false, default: 0
      t.text :content, null: false, default: ""
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
