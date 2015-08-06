# Public: Helpers for the modal.
module ModalHelper
  # Public: Generates the javascript to add html classes to indicate errors on
  # an input field.
  #
  # Returns a String containing javascript code.
  def add_error_classes(resource)
    js = resource.errors.map do |field|
      field_id = '#' + resource.class.name.underscore + '_' + field.to_s
      "$( '#{field_id}' ).parent().addClass( 'has-error' );"
    end

    js.join("\n").html_safe
  end
end