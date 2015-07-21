class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, :body, presence: true
  validates :user_id, presence: true
  validates :title, length: { maximum: 150 }

  accepts_nested_attributes_for :attachments

  def best_answer
    self.answers.where(best: true).first
  end
end
