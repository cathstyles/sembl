ActiveAdmin.register Board do
  permit_params :title, :number_of_players, :nodes_attributes, :links_attributes

  filter :creator, collection: proc { User.includes(:profile).all }
  filter :updator, collection: proc { User.includes(:profile).all }
  attributes_to_exclude_from_filter = ["creator_id", "updator_id"]
  (Board.attribute_names - attributes_to_exclude_from_filter).sort.each do |attr|
    filter attr.to_sym
  end

  index do
    selectable_column
    column :title
    column "players", :number_of_players
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :number_of_players
      f.input :nodes_attributes, as: :text
      f.input :links_attributes, as: :text
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
