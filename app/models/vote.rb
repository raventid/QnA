class Vote < ActiveRecord::Base  
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, :value, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: { in: [-1, 1] }

  after_commit :add_vote_to_rating, on: [:create, :destroy]

  private

  def add_vote_to_rating
    return if marked_for_destruction? # when deletion throw 'dependent: :destroy'
    if destroyed?
      votable.decrement!(:rating, value)
    else
      votable.increment!(:rating, value)
    end
  end

end
