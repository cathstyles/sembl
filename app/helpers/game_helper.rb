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
  
end
