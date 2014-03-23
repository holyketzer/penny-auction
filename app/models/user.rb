class User < ActiveRecord::Base
  has_many :authorizations
  has_many :bids
  has_one :avatar
  belongs_to :role
  has_many :permissions, through: :role

  validates :nickname, presence: true
  validates :nickname, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte]

  before_create { |user| user.role = Role.default_role unless user.role }

  scope :bots, -> { where(role: Role.bot) }

  def self.random_bot
    bots.order('RANDOM()').first
  end

  def admin?
    role == Role.admin
  end

  def bot?
    role == Role.bot
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    if authorization
      user = authorization.user
    else
      email = auth.info[:email]
      nickname = auth.info[:nickname]
      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      elsif email.present? && nickname.present?
        password = Devise.friendly_token[0, 20]
        user = User.create(email: email, password: password, password_confirmation: password, nickname: nickname)
        user.create_authorization(auth)
      end
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def add_authorization(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    if authorization
      authorization.user == self
    else
      create_authorization(auth)
      true
    end
  end
end
