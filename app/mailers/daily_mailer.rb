class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Questions.lastday
    mail to: user.email, subject: "The latest questions digest!"
  end
end
