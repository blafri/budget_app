# Public: Model class for user table
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])

    # This section creates the user if he does not already exist
    unless user
      user = User.new(email: data['email'],
                      password: Devise.friendly_token[0, 20])
      user.skip_confirmation!
      user.save!
    end

    user
  end
end
