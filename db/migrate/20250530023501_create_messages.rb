class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :creator, null: false, polymorphic: true

      t.text :content, null: false

      t.timestamps
    end
  end
end
