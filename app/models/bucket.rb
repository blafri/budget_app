# Public: Model for buckets database table.
class Bucket < ActiveRecord::Base
  belongs_to :user

  has_many :acct_trans, as: :transactable

  validates :user, :name, presence: true
end
