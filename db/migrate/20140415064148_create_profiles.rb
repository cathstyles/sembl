class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user 
      t.string :name
      t.text :bio 
      t.string :avatar
    end

    User.find_each do |user|
      p = Profile.create(name: user.email.split('@')[0],  user: user)
      p.save!
    end
  end
end
