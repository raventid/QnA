class Vote < ActiveRecord::Base  
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, :weight, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :weight, inclusion: { in: [-1, 1] }

  after_commit :add_vote_to_rating, on: [:create, :destroy]
  after_commit :change_vote_to_rating, on: [:update]

  def add_vote_to_rating
    return if marked_for_destruction? # when deletion throu dependent: :destroy
    if destroyed?
      votable.decrement!(:rating, weight)
    else
      votable.increment!(:rating, weight)
    end
  end

  def change_vote_to_rating
    votable.increment!(:rating, weight * 2)
  end
end
