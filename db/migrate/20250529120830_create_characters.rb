class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.string :name, null: false
      t.text :prompt

      t.timestamps
    end
  end
end
