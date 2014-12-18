ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role
  config.sort_order = "updated_at_desc"
  includes :profile

  filter :role, collection: User.roles, as: :select
  User.attribute_names.sort.each do |attr|
    filter attr.to_sym
  end

  index do
    selectable_column
    column :email
    column :created_at
    column :last_sign_in_at
    column :role do |user|
      User.roles.invert[user.role]
    end
    column :name do |user|
      user.profile.try(:name)
    end
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
     f.input :email
     f.input :role, as: :select, collection: User.roles, include_blank: false
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do |user|
    attributes_table do
      row :name
      row :bio
      row :avatar do
        image_tag user.avatar.url
      end
      User.attribute_names.sort.each do |attr|
        row attr.to_sym
      end
    end
    active_admin_comments
  end
end
