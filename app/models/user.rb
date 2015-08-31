class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def voted_for?( votable )
    return true if Vote.find_by(votable_id: votable.id, votable_type: votable.class.name, user_id: self.id)

    false
  end

  #this method return nil if user did not vote for this resource
  def get_vote_object( votable )
    return Vote.find_by(votable_id: votable.id, votable_type: votable.class.name, user_id: self.id)
  end

end
