module GameHelper
  
  def render_seed_thing(thing)
    class_name = 'seed'
    class_name << ' selected' if @game.seed_thing.id == thing.id

    content_tag(:div,
      image_tag(thing.image.admin_thumb.url, alt: thing.title),
      class: class_name, 
      data: {id: thing.id}
    )
  end
end
