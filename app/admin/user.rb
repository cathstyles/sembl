ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role
  config.sort_order = "updated_at_desc"
  scope :all, default: true
  User.roles.each do |role_name, role_id|
    scope(role_name) { |scope| scope.where(role: role_id) }
  end
  includes :profile

  filter :role, collection: User.roles, as: :select
  filter :profile_name, as: :string
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

  User.roles.each do |role_name, role_id|
    batch_action "Set role to #{role_name} for".to_sym do |ids|
      User.find(ids).each do |user|
        user.role = role_id
        user.save!
      end
      redirect_to collection_path, alert: "Selected users have been updated to #{role_name.to_s.humanize}s"
    end
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
     f.input :email
     f.input :role, as: :select, collection: User.roles, include_blank: false
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
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
    panel "Email" do
      render "email_form"
    end
    active_admin_comments
  end

  member_action :message, method: :post do
    Admin::UserMailer.email_message(user_id: resource.id, subject: params[:subject], content: params[:content]).deliver
    redirect_to resource_path(resource), notice: "Email sent to user"
  end
end
