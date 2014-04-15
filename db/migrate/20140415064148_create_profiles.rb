class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user 
      t.string :name
      t.text :bio 
      t.string :avatar
    end

    User.find_each do |user|
      user.profile = Profile.create(user: user)
    end
  end
end
