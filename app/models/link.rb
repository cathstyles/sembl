class Link < ActiveRecord::Base
  belongs_to :game
  belongs_to :source, class_name: Node
  belongs_to :target, class_name: Node
  has_many :resemblances, dependent: :destroy

  def round
    target.round
  end

  def player_resemblance(user)
    resemblances.with_state(:proposed).where(creator: user).take unless !user
  end

  def final_resemblance
    resemblances.with_state(:final).take
  end 

  def viewable_resemblance(user)
    final_resemblance || player_resemblance(user)
  end
end
