ActiveAdmin.register Thing do
  permit_params :title, :description, :item_url, :copyright, :access_via, :general_attributes, :image, :suggested_seed, :moderator_approved, :sensitive, :mature
  includes({ creator: :profile })

  # We want all the filters minus the "game" association filter (which loads too many records from the db)
  # and use association filters for "creator" and "updator"
  filter :creator, collection: proc { User.includes(:profile).all }
  filter :updator, collection: proc { User.includes(:profile).all }
  attributes_to_exclude_from_filter = ["game_id", "creator_id", "updator_id"]
  (Thing.attribute_names - attributes_to_exclude_from_filter).sort.each do |attr|
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

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      input :title
      input :description
      input :item_url
      input :copyright
      input :access_via
      input :general_attributes, as: :text, label: "Attributes"
      input :image
      input :suggested_seed, label: "Suggested seed node"
      input :moderator_approved, label: "Allow thing to be used in all games?"
      input :sensitive, label: "Mark as culturally sensitive?"
      input :mature, label: "Mark as mature?"
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
