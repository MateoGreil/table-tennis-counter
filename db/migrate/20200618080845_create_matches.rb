class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.boolean :winner
      t.references :t_one, foreign_key: { to_table: :teams }
      t.references :t_two, foreign_key: { to_table: :teams }
      t.integer :t_one_score
      t.integer :t_two_score
      t.integer :rule, null: false

      t.timestamps
    end
  end
end
