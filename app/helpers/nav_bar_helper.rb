# Public: The helpers to format the nav bar go in this module.
module NavBarHelper
  # Public: sets up the links so the user can either sign in or sign up if
  # they are not authenticated or go to account settings or sign out if they are
  # authenticated.
  #
  # Returns a String containg HTML links.
  def user_links
    generate_nav_links([acc_link, log_out_link, sign_up_link, log_in_link])
  end

  def main_links
    generate_nav_links([home_link, bank_account_links])
  end

  private

  # Internal: Generates the HTML links wrapped in list tags for use in the nav
  # bar.
  #
  #  links - An Array of links to format. Each value in the array should be a
  #          hash containing the following keys:
  #          :html -> The html for the link
  #          :active -> A boolean value indicating wether the active class
  #                     should be added to the links list element
  #
  # Returns a String with html for the links.
  def generate_nav_links(links)
    html = links.compact.map do |link_info|
      active = link_info[:active] ? 'active' : nil
      dropdown = link_info[:dropdown] ? 'dropdown' : nil

      if active || dropdown
        content_tag :li, link_info[:html], class: [active, dropdown]
      else
        content_tag :li, link_info[:html]
      end
    end

    html.join.html_safe
  end

  # Internal: Generates the links for the bank accounts dropdown menu on the
  # navbar.
  #
  # Returns a Hash containing info to create the link.
  def bank_account_links
    return unless user_signed_in?

    html = '<a href="#" class="dropdown-toggle" data-toggle="dropdown" '\
           'role="button" aria-haspopup="true" aria-expanded="false">Bank '\
           'Accounts <span class="caret"></span></a>'.html_safe

    html += content_tag :ul, user_bank_account_links, class: 'dropdown-menu'

    { html: html }
  end

  def user_bank_account_links
    html = current_user.bank_accounts.map do |bank_account|
      user_bank_account_link(bank_account)
    end

    html << content_tag(:li, link_to('Add New Account', new_bank_account_path))

    html.compact.join.html_safe
  end

  def user_bank_account_link(ba)
    return unless ba.persisted?

    content_tag :li, link_to(ba.name, bank_account_path(ba)),
                id: "nav_bank_account_#{ba.id}"
  end

  # Internal: Generates info for the home link.
  #
  # Returns an Hash containing info to create the link.
  def home_link
    path = root_path
    {
      html: link_to('Home', path),
      active: request.env['PATH_INFO'] == path
    }
  end

  # Internal: Determmines if the account settings link should be shown. If it
  # should be shown it returns a hash of link info.
  #
  # Returns an Hash containing info to create the link or nil if the link
  #   should not be shown.
  def acc_link
    return unless user_signed_in?

    path = '#'
    {
      html: link_to('Account Settings', path),
      active: request.env['PATH_INFO'] == path
    }
  end

  # Internal: Determmines if the log out link should be shown. If it
  # should be shown it returns a hash of link info.
  #
  # Returns an Hash containing info to create the link or nil if the link
  #   should not be shown.
  def log_out_link
    return unless user_signed_in?

    {
      html: link_to('Log Out', destroy_user_session_path, method: :delete),
      active: false
    }
  end

  # Internal: Determmines if the log in link should be shown. If it
  # should be shown it returns a hash of link info.
  #
  # Returns an Hash containing info to create the link or nil if the link
  #   should not be shown.
  def log_in_link
    return if user_signed_in?

    path = new_user_session_path
    {
      html: link_to('Log In', path),
      active: request.env['PATH_INFO'] == path
    }
  end

  # Internal: Determmines if the sign_up link should be shown. If it
  # should be shown it returns a hash of link info.
  #
  # Returns an Hash containing info to create the link or nil if the link
  #   should not be shown.
  def sign_up_link
    return if user_signed_in?

    path = new_user_registration_path
    {
      html: link_to('Sign Up', path),
      active: request.env['PATH_INFO'] == path
    }
  end
end
