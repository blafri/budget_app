require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DashboardsHelper. For example:
#
# describe DashboardsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  context '#form_group_tag' do
    it 'returns proper html when they are no errors' do
      errors = double(any?: false)

      output = content_tag :div, 'test', class: 'form-group'

      expect(helper.form_group_tag(errors) { 'test' }).to eq(output)
    end

    it 'returns proper html when they are errors present' do
      errors = double(any?: true)

      output = content_tag :div, 'test', class: 'form-group has-error'

      expect(helper.form_group_tag(errors) { 'test' }).to eq(output)
    end
  end

  context '#display_form_errors' do
    it 'returns nothing if they are no errors' do
      errors = double(errors: double(empty?: true))
      expect(helper.display_form_errors(errors)).to eq('')
    end

    it 'returns proper html if they are errors' do
      errors = double(errors: double(empty?: false, full_messages: ['message1', 'message2']))

      expected_output = '<div class=\'alert alert-danger\'><ul class='\
                        '\'list-unstyled\'><li>message1</li><li>message2</li>'\
                        '</ul></div>'

      expect(helper.display_form_errors(errors)).to eq(expected_output)
    end
  end
end
