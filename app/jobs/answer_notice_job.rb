class AnswerNoticeJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscription.find_each do |subscription|
      SubscriptionMailer.notice(subscription.user, answer).deliver_later
    end
  end
end
