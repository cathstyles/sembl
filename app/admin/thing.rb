ActiveAdmin.register Thing do
  permit_params :title, :description, :item_url, :copyright, :access_via, :image, :suggested_seed, :moderator_approved, :sensitive, :mature, :dates, :keywords, :places, :node_type
  config.sort_order = "updated_at_desc"
  includes({ creator: :profile })

  # We want all the filters minus the "game" association filter (which loads too many records from the db)
  # and use association filters for "creator" and "updator"
  filter :creator_role, as: :check_boxes, collection: proc { User.roles }
  filter :moderator_approved
  filter :title
  filter :description
  filter :created_at
  filter :updated_at
  filter :creator, collection: proc { User.includes(:profile).all }
  filter :updator, collection: proc { User.includes(:profile).all }
  attributes_to_exclude = ["game_id", "creator_id", "updator_id", "title", "description", "created_at", "updated_id"]
  (Thing.attribute_names - attributes_to_exclude).sort.each do |attr|
    filter attr.to_sym
  end

  index do
    selectable_column
    column :image do |thing|
      if thing.image?
        link_to edit_admin_thing_path(thing) do
          image_tag thing.image.admin_thumb.url, alt: thing.description, class: "thing-image"
        end
      end
    end
    column :title
    column :description
    column :access_via
    column "Uploaded", :created_at
    column :creator
    column "User uploaded", :user_contributed do |thing|
      thing.user_contributed? ? "Yes" : "No"
    end
    actions
  end

  form(:html => { :multipart => true }) do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :description
      f.input :item_url
      f.input :copyright
      f.input :access_via
      f.input :dates
      f.input :keywords
      f.input :places
      f.input :node_type
      f.input :image, as: :file, hint: f.template.image_tag(f.object.image.url)
      f.input :suggested_seed, label: "Suggested seed node"
      f.input :moderator_approved, label: "Allow thing to be used in all games?"
      f.input :sensitive, label: "Mark as culturally sensitive?"
      f.input :mature, label: "Mark as mature?"
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    attributes_table do
      (Thing.attribute_names - ["image"]).sort.each do |attr|
        row attr.to_sym
      end
      row :image do |thing|
        image_tag thing.image.url
      end
    end
    active_admin_comments
  end
end
