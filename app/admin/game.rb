ActiveAdmin.register Game do
  permit_params :title, :description, :theme, :invite_only, :uploads_allowed, :allow_keyword_search
  config.sort_order = "updated_at_desc"
  scope :not_stale, default: true
  scope :all
  includes(:board)

  # Override ActiveAdmin auto filters so we can optimize queries
  filter :title
  filter :board
  filter :created_at
  filter :updated_at
  filter :creator, collection: proc { User.includes(:profile).all }
  filter :updator, collection: proc { User.includes(:profile).all }
  attributes_to_exclude = ["board_id", "creator_id", "updator_id", "title", "created_at", "updated_at", "state_changed_at"]
  (Game.attribute_names - attributes_to_exclude).sort.each do |attr|
    filter attr.to_sym
  end

  index do
    selectable_column
    column :title
    column :board
    column :status do |game|
      (game.invite_only) ? "Invite only" : "Open"
    end
    column "Created", :created_at
    column "Last Activity" do |game|
      time_ago_in_words(game.updated_at) + " ago"
    end
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :description
      f.input :theme
      f.input :invite_only
      f.input :uploads_allowed
      f.input :allow_keyword_search
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
