# rule                :integer
# first_team          :references   not null
# second_team         :references   not null
# winner              :references
# first_team_points   :integer      not null  default: 0
# second_team_points  :integer      not null  default: 0
# match               :references
# round               :integer
class Game < ApplicationRecord
  enum rule: %i[11 21]

  belongs_to :first_team, class_name: 'Team'
  belongs_to :second_team, class_name: 'Team'
  belongs_to :winner, class_name: 'Team', optional: true
  belongs_to :match, optional: true

  accepts_nested_attributes_for :first_team, :second_team

  validate :impossible_points?

  before_save :set_winner, if: :there_is_a_winner?

  def first_team_status
    if winner.nil?
      :in_progress
    elsif winner == first_team
      :winner
    else
      :looser
    end
  end

  def second_team_status
    if winner.nil?
      :in_progress
    elsif winner == second_team
      :winner
    else
      :looser
    end
  end

  private

  def impossible_points?
    if first_team_points >= rule.to_i - 1 &&
       second_team_points >= rule.to_i - 1 &&
       (first_team_points - second_team_points).abs > 2
      errors.add(:first_team_points, :impossible_points)
      errors.add(:second_team_points, :impossible_points)
    end
  end

  def there_is_a_winner?
    if (first_team_points >= rule.to_i || second_team_points >= rule.to_i) &&
       (first_team_points - second_team_points).abs >= 2
      return true
    end

    false
  end

  def set_winner
    self.winner = if first_team_points > second_team_points
                    first_team
                  else
                    second_team
                  end
  end
end
