module GameHelper

  def render_seed_thing(thing)
    class_name = 'seed'
    class_name << ' selected' if @game.seed_thing.try(:id) == thing.id

    content_tag(:div,
      image_tag(thing.image.admin_thumb.url, alt: thing.title),
      class: class_name,
      data: {id: thing.id}
    )
  end

  def new_invite_fields(form)
    fields = form.fields_for(:players, Player.new, :child_index => "new_player") do |builder|
      render("player_fields", :f => builder)
    end
    fields.to_str
  end

  def invited_players_tag(form)
    content_tag :div, {
      class: 'invited-players',
      data: {new: new_invite_fields(form)},
      style: ("display: none" unless @game.invite_only) } do
        yield
    end
  end

  # def required_players
  #   return @game.players.build if @game.number_of_players.blank?

  #   players_required = @game.number_of_players - @game.players.count
  #   players_required.times {|p| @game.players.build }
  #   @game.players
  # end

  def boards_for_select
    Board.all.map {|b| [b.title_with_players, b.id, "data-number_of_players" => b.number_of_players] }
  end

  def games_filter_title(filter)
    case filter
    when :hosted
      "Games you’re hosting"
    when :open
      "Open games"
    when :browse
      "Games in progress"
    when :completed
      "Completed games"
    when :user_completed
      "Your completed games"
    else
      "Games you’re playing"
    end
  end

  def user_initials(user)
    name = if user.profile.name.present? && user.profile.name != ""
      user.profile.name
    else
      user.email
    end
    # Get initials from name
    name.split(' ').collect do |word|
      word[0,1].upcase
    end.join('')
  end

  def player_state_message(player)
    case player.state
    when :playing_turn
      "playing their turn"
    when :rating
      "rating sembls"
    when :invited
      "invited"
    when :finished
      "finished"
    else
      "waiting"
    end
  end

end
