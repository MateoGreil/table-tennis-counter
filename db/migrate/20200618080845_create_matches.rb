class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.references :winner, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
