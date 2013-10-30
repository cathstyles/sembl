class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, Board
      can :manage, Game
    end
    
    # Game hosting permissions
    #
    can :create, Game
    can :new, Game
    can :edit, Game, creator_id: user.id do |game| 
      game.editable?
    end
    can :update, Game, creator_id: user.id do |game| 
      game.editable?
    end
    can :destroy, Game, creator_id: user.id do |game| 
      game.editable?
    end
    can :pause, Game, creator_id: user.id do |game|
      game.in_progress?
    end
    can :invite_users, creator_id: user.id do |game| 
      game.editable?
    end


    # Game playing permissions 
    can :view, Game do |game|
      !game.invite_only ||
      game.participating?(user) ||
      game.creator_id == user.id
    end
    can :join, Game.open_to_join
    can :play, Game.participating(user) do |game|
      game.in_progress?
    end 

    # Node placement permissions
    can :create, Placement do |placement|
      placement.node.available_to?(user)
    end
    can :edit, Placement, {creator_id: user.id} do |placement|
      placement.node.game.player(user).state == "completing_turn"
    end
    can :update, Placement, {creator_id: user.id} do |placement|
      placement.node.game.player(user).state == "completing_turn"
    end
    can :destroy, Placement, {creator_id: user.id} do |placement|
      placement.node.game.player(user).state == "completing_turn"
    end

    # Resemblance entry permissions
    can :create, Resemblance do |resemblance|
      resemblance.link.available_to?(user)
    end
    can :edit, Resemblance, {creator_id: user.id} do |resemblance|
      resemblance.link.game.player(user).state == "completing_turn"
    end
    can :update, Resemblance, {creator_id: user.id} do |resemblance|
      resemblance.link.game.player(user).state == "completing_turn"
    end
    can :destroy, Resemblance, {creator_id: user.id} do |resemblance|
      resemblance.link.game.player(user).state == "completing_turn"
    end

    # TODO check we are rating for the current round.
    can :rate, Resemblance do |resemblance|
      resemblance.creator != user &&
      resemblance.game.state == "rating" &&  
      resemblance.game.participating?(user) 
    end

    # End turn
    can :end_turn, Player, {user_id: user.id, state: "completing_turn"} do |player|
      player.can_end_turn?
    end



  end
end
