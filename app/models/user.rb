# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :integer          default(1), not null
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :games, through: :player
  before_create :join_games

  ROLES = {
    :participant => 1,
    :power => 2,
    :admin => 10,
    :banned => 0
  }.freeze

  state_machine :role, initial: :participant do 
    ROLES.each do |name, value|
      state name, :value => value
    end 

    event :make_participant do 
      transition all => :participant
    end

    event :make_power_user do 
      transition all => :power
    end 

    event :make_admin do 
      transition all => :admin
    end 

    event :ban do 
      transition all => :banned
    end
  end 

  def to_s
    email
  end

  def join_games
    Player.find_by_email(email).try(:each) do |player|
      player.user = self
      if player.save 
        # Only transition state to playing if player has actually been sent an invitation.
        player.join if player.invited? 
      else
        errors.add(:base, "Could not join the game #{player.game.title}, hosted by #{player.game.creator.email}.") 
      end
    end
  end

end
