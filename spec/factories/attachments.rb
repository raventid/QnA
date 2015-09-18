FactoryGirl.define do
  factory :attachment do
    file { File.new(Rails.root.join('config.ru')) }
  end

  factory :question_attachment, class:'Attachment' do
    file ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    attachable { |a| a.association(:question) }
  end

  factory :answer_attachment, class:'Attachment' do
    file ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    attachable { |a| a.association(:answer) }
  end

end
