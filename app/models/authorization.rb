class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :uid, :provider, :user_id, presence: true
end
