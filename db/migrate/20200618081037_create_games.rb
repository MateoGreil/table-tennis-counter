class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.boolean :winner
      t.references :match, null: true, foreign_key: true
      t.references :t_one, foreign_key: { to_table: :teams }
      t.references :t_two, foreign_key: { to_table: :teams }
      t.integer :t_one_score, default: 0
      t.integer :t_two_score, default: 0
      t.integer :rule, null: false

      t.timestamps
    end
  end
end
