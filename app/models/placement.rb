class Placement < ActiveRecord::Base
  belongs_to :node
  belongs_to :thing
  belongs_to :creator, class_name: "User"

  HUMANIZED_ATTRIBUTES = {
    :thing => "Image"
  }

  validates_presence_of :thing

  after_create :reify_seed_node

  # == States
  #   proposed
  #   final
  state_machine initial: :proposed do
    after_transition :proposed => :final, do: :fill_node

    event :reify do
      transition :proposed => :final
    end
  end

  def self.human_attribute_name(attr, default: attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


  def self.for_round(game, round = nil)
    round  = round || game.current_round
    joins(:node).where("nodes.game_id = ? and nodes.round = ?", game.id, round)
  end

  def self.for_game(game)
    joins(:node).where("nodes.game_id = ?", game)
  end

  def fill_node
    node.fill
  end

  def reify_seed_node
    if node.round == 0
      self.reify
    end
  end

end
