class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.references :winner, foreign_key: { to_table: :teams }
      t.integer :rule, null: false

      t.timestamps
    end
  end
end
