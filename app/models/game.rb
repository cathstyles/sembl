# == Schema Information
#
# Table name: games
#
#  id                   :integer          not null, primary key
#  board_id             :integer
#  title                :string(255)      not null
#  description          :text
#  creator_id           :integer
#  updator_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  invite_only          :boolean          default(FALSE)
#  uploads_allowed      :boolean          default(FALSE)
#  theme                :string(255)
#  filter_content_by    :text
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)      default("draft")
#  current_round        :integer          default(1)
#  random_seed          :integer
#

class Game < ActiveRecord::Base
  validates :title, presence: true
  validates :board, presence: true

  belongs_to :board

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  has_many :users, through: :players
  has_many :players

  has_many :nodes
  has_many :links

  before_create :generate_random_seed

  # Games still open to users to join
  def self.open_to_join
    where(invite_only: false).
      joins(:board).
      includes(:players).
      group("games.id, boards.number_of_players, players.id").
      having("count(players.id) < boards.number_of_players").
      references(:players)
  end

  def self.completed
    where(state: 'completed')
  end

  def self.in_progress
    where("games.state != 'draft' AND games.state != 'completed'")
  end

  def self.invite_only
    where(invite_only: true)
  end

  def self.participating(current_user)
      joins(:users).where(["users.id = ?", current_user.try(:id)])

  end

  def self.hosted_by(current_user)
    where(creator: current_user)
  end

  def seed_thing
    seed_node = nodes.where(round: 0).take
    seed_node.final_placement.try(:thing)
  end

  def open_to_join?
    invite_only == false && 
    users.count < board.number_of_players
  end

  def in_progress? 
    state == 'open' || state == 'playing' || state == 'rating'
  end

  # Only editable if no players have joined
  def editable?
    state == 'draft' || !game.players.present?
  end

  def participating?(user)
    users.include?(user)
  end

  def player(current_user)
    players.where(user: current_user).take
  end


  # Copy nodes and links from board
  def copy_board_to_game
    return unless board.present? 

    nodes.destroy_all
    links.destroy_all

    node_array = []
    board.nodes_attributes.each do |node_attr|
      node_array << nodes.create(node_attr.except('fixed'))
    end

    board.links_attributes.each do |link_attr| 
      links.create(
        source: node_array[link_attr['source']],
        target: node_array[link_attr['target']]
      )
    end

  end

  private 

    def generate_random_seed
      self.random_seed = SecureRandom.random_number(2147483646)
    end

end
