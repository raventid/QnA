class AddRatingToAnswersAndQuestions < ActiveRecord::Migration
  def change
  	add_column :answers, :rating, :integer, default: 0
    add_column :questions, :rating, :integer, default: 0
  end
end