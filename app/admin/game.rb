ActiveAdmin.register Game do
  permit_params :title, :description, :theme, :invite_only, :uploads_allowed, :allow_keyword_search
  includes(:board)

  # Override ActiveAdmin auto filters so we can optimize queries
  filter :board # need to manually include this as it's an association
  filter :creator, collection: proc { User.includes(:profile).all }
  filter :updator, collection: proc { User.includes(:profile).all }
  attributes_to_exclude_from_filter = ["board_id", "creador_id", "updator_id"]
  (Game.attribute_names - attributes_to_exclude_from_filter).sort.each do |attr|
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
      input :title
      input :description
      input :theme
      input :invite_only
      input :uploads_allowed
      input :allow_keyword_search
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
