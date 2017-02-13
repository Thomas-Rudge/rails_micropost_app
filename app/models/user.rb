class User < ApplicationRecord

  attr_accessor :remember_token

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  NAME_REGEX  = /[\t|\r|\n|\f]+/m

  before_save { email.downcase! }

  validates :name,  presence: true,
                    length: { in: 2..50 },
                    format: { without: NAME_REGEX }

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 254 },
                    format: { with: EMAIL_REGEX }

  has_secure_password
  validates :password, confirmation: true,
                       presence: true,
                       length: { minimum: 6 }

  validates :password_confirmation, presence: true

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_token.blank?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
