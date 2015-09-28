class SubscriptionMailer < ApplicationMailer
  def notice(user, answer)
    @answer = answer
    mail to: user.email, subject: "New answer to #{answer.question.title}"
  end
end
