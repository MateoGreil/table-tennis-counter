class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.references :first_team, null: false, foreign_key: { to_table: :teams }
      t.references :second_team, null: false, foreign_key: { to_table: :teams }
      t.references :winner, null: true, foreign_key: { to_table: :teams }
      t.integer :first_team_points
      t.integer :second_team_points
      t.integer :rule, null: false
      t.integer :games_rule, null: false

      t.timestamps
    end
  end
end
