class Thing < ActiveRecord::Base
  include RandomFixedOrderable

  validates :image, presence: true

  belongs_to :creator, class_name: 'User', inverse_of: :created_things
  belongs_to :updator, class_name: 'User', inverse_of: :updated_things

  belongs_to :game # only when it's uploaded by a user

  after_create :add_to_search_index
  after_update :add_to_search_index

  mount_uploader :image, ImageUploader

  def self.filter_keys
    Thing.distinct.pluck("json_object_keys(json_array_elements(general_attributes))")
  end

  ### Scopes

  def self.not_user_uploaded
    where(game_id: nil)
  end

  def self.moderator_approved
    where(moderator_approved: true)
  end

  ### Commands

  # Return JSON serialization needed for the kind of search queries we use.
  def as_indexed_json(options={})
    as_json(options).merge({"moderator_approved_user_contribution" => moderator_approved_user_contribution?})
  end

  def add_to_search_index
    Services.search_service.index(self)
  end

  ### Predicates

  def moderator_approved_user_contribution?
    user_contributed? && moderator_approved
  end

  def user_contributed?
    game_id.present?
  end
end
