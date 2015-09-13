# User class
class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  def voted_for?(votable)
    return true if Vote.find_by(votable_id: votable.id, votable_type: votable.class.name, user_id: id)
    false
  end

  # this method return nil if user did not vote for this resource
  def vote_for(votable)
    Vote.find_by(votable_id: votable.id, votable_type: votable.class.name, user_id: id)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    return User.new unless auth.info.email.present?

    email = auth.info.email
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      user = generate_user(email)
      user.create_authorization(auth)
    end

    user
  end

  def self.generate_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
