module ApplicationHelper
  def modular_application_name
    @@application_name ||= Rails.application.class.name.sub(/::Application\Z/, "").underscore
  end

  def modular_controller_name
    @@modular_controller_name ||= controller.class.name.sub(/Controller\Z/, "").underscore
  end

  def body_classes
    @body_classes ||= [
      modular_application_name.parameterize,
      modular_controller_name.parameterize,
      [modular_controller_name, action_name].join("-").parameterize,
    ].compact
  end

  def flashes
    safe_join(flash.keys.map { |key|
      content_tag :aside, flash[key], class: [:flash, key]
    })
  end
end
