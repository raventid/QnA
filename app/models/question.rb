class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  scope :lastday, -> { where(updated_at: Time.current.yesterday.all_day) }

  validates :title, :body, presence: true
  validates :user_id, presence: true
  validates :title, length: { maximum: 150 }

  # after_create :notify_the_subscriber
  after_create :create_subscribe_for_author

  def best_answer
    self.answers.where(best: true).first
  end

  private

  # def notify_the_subscriber
  #   AnswerNoticeJob.perform_later(self)
  # end

  def create_subscribe_for_author
    Subscription.create(user: self.user, question: self)
  end
end
