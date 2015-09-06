class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :user_id, presence: true
  validates :title, length: { maximum: 150 }

  def best_answer
    self.answers.where(best: true).first
  end
end
