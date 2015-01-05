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

  show do
    tabs do
      tab 'Sembls' do
        panel "Sembls" do
          render 'sembls'
        end
      end
      tab 'Details' do
        attributes_table do
          row "Public link" do
            link_to "link", game
          end
          row :players do
            game.players.each_with_index do |player, index|
              text_node link_to(player.name, admin_user_path(player.user, game_id: game.id)) + ": " + player.state
              text_node ", " if index < game.users.length - 1
            end
          end
          Game.attribute_names.sort.each do |attr|
            row attr.to_sym
          end
        end
        active_admin_comments
      end

    end
  end
end
