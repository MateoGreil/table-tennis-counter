class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :winner, foreign_key: { to_table: :teams }
      t.references :match, null: true, foreign_key: true
      t.integer :rule, null: false

      t.timestamps
    end
  end
end
