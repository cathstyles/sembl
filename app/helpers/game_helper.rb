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

  def new_player_invite_field(form)
     fields = form.fields_for(:players, Player.new, :child_index => "new_players") do |builder|
      render("player_fields", :f => builder)
    end

    content_tag(:div, nil, {id: 'new-player-fields', data: {fields: fields.to_str}})
  end

  def boards_for_select
    Proc.new { 
      Board.all.map {|b| [b.title_with_players, b.id, "data-number_of_players" => b.number_of_players] }
    }
  end 

end
