module AdminHelper
  # Like time_tag, but makes the default text a time ago and
  # includes a title attribute with full localized time
  def time_ago_tag time, *args
    options = args.extract_options!
    options.reverse_merge! title: l(time)

    text = args.shift
    text ||= "#{time_ago_in_words(time)} ago"

    time_tag time, text, *args, options
  end

  def friendly_game_state(game)
    case game.state
    when :joining
      "Waiting for players"
    when :playing
      "In progress"
    else
      game.state.capitalize
    end
  end

  def friendly_user_role(user)
    role = User.roles.find {|name, value| value == user.role}
    case role[0]
    when :power
      "Host"
    else
      role[0].capitalize
    end
  end
end
