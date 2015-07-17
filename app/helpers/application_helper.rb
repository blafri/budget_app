# Public: This is the main helper file for the application
module ApplicationHelper
  # Public: prints out classes for use on the body tag to indicate what
  # controller and action generated the current page. this info can be used for
  # javascript and css that you want to apply specifically to the controller,
  # action or a combination of both
  #
  # Returns a string with class names
  def page_controller_classes
    controller = controller_name
    action = action_name
    "#{controller} #{action} #{controller}-#{action}"
  end

  def form_group_tag(errors, &block)
    unless errors.any?
      return content_tag :div, capture(&block), class: 'form-group'
    end

    content_tag(:div, capture(&block), class: 'form-group has-error')
  end

  def display_form_errors(resource)
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }
               .join

    html = <<-EOS
<div class='alert alert-danger'>
  <ul class='list-unstyled'>
    #{messages}
  </ul>
</div>
EOS

    html.html_safe
  end
end
