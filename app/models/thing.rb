class Thing < ActiveRecord::Base
  include RandomFixedOrderable

  validates :image, presence: true

  belongs_to :creator, class_name: 'User', inverse_of: :created_things
  belongs_to :updator, class_name: 'User', inverse_of: :updated_things

  belongs_to :game # only when it's uploaded by a user

  mount_uploader :image, ImageUploader

  searchable do
    text :title, default_boost: 2
    text :description
    text :attribution
    text :access_via
    text :copyright
    text :dates
    text :keywords
    text :places
    text :node_type

    integer :game_id
    integer :creator_id
    integer :updator_id

    integer :random_seed
    boolean :suggested_seed

    boolean :user_contributed do
      user_contributed?
    end
    boolean :moderator_approved do
      moderator_approved?
    end
    boolean :sensitive
    boolean :mature

    time :created_at
    time :updated_at
  end

  ### Scopes

  def self.not_user_uploaded
    where(game_id: nil)
  end

  def self.user_uploaded
    where.not(game_id: nil)
  end

  def self.moderator_approved
    where(moderator_approved: true)
  end

  ### Predicates

  def user_contributed?
    game_id.present?
  end
end
