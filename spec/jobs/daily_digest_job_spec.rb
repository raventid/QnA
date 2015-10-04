require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_pair(:user) }
  let(:yesterday_questions) { create_pair(:old_question, user: users.first) }
  let!(:today_questions) { create_pair(:question, user: users.first) }

  it 'sends daily digest' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
