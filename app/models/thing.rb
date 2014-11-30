class Thing < ActiveRecord::Base
  include RandomFixedOrderable

  validates :image, presence: true

  belongs_to :creator, class_name: 'User', inverse_of: :created_things
  belongs_to :updator, class_name: 'User', inverse_of: :updated_things

  belongs_to :game # only when it's uploaded by a user

  mount_uploader :image, ImageUploader

  # Must appear before `searchable` so we can refer to it there
  def self.filter_keys
    Thing.distinct.pluck("json_object_keys(general_attributes)")
  end

  searchable do
    text :title, default_boost: 2
    text :description
    text :attribution
    text :access_via
    text :copyright

    special_filter_keys = %w(Keywords Places Date/s)
    text :general_attributes_keywords do
      Array.wrap(general_attributes["Keywords"]).join(" ")
    end
    text :general_attributes_places do
      Array.wrap(general_attributes["Places"]).join(" ")
    end
    text :general_attributes_dates do
      Array.wrap(general_attributes["Date/s"]).join(" ")
    end

    (filter_keys - special_filter_keys).each do |filter_key|
      searchable_filter_key = filter_key.downcase.gsub(/[^a-z]/, "").gsub(/\s+/, "_")

      if filter_key =~ /^Mark:/
        boolean :"general_attributes_#{searchable_filter_key}", multiple: true do
          general_attributes[filter_key]
        end
      else
        string :"general_attributes_#{searchable_filter_key}", multiple: true do
          general_attributes[filter_key]
        end
      end
    end

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

  def self.moderator_approved
    where(moderator_approved: true)
  end

  ### Predicates

  def user_contributed?
    game_id.present?
  end
end
