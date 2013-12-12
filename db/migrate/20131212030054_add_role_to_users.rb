class AddRoleToUsers < ActiveRecord::Migration
  def up
    add_column :users, :role, :integer, null: false, default: 1

    User.reset_column_information
    User.find_each do |user|
      begin 
        user.role = user.admin ? 10 : 1
        user.save!
      rescue
        puts "Error creating role for #{user.email}"
      end
    end

    remove_column :users, :admin
  end

  def down
    add_column :users, :admin, :boolean, null: false, default: false

    User.reset_column_information
    User.find_each do |user|
      begin 
        user.admin = (user.role == 10)
        user.save!
      rescue
        puts "Error rolling back role for user: #{user.email}"
      end
    end

    remove_column :users, :role
  end
end
