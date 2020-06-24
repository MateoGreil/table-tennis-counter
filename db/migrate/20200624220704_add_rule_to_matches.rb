class AddRuleToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :rule, :integer
  end
end
