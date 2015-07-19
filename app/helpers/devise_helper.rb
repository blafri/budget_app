# Public: All devise helper methods shoulds be placed in this module
module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }
               .join

    html = <<-EOS
<div class='alert alert-danger text-center'>
  <ul class='list-unstyled'>
    #{messages}
  </ul>
</div>
EOS

    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end
