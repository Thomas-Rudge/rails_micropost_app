class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  NAME_REGEX  = /[\t|\r|\n|\f]+/m

  before_save   :downcase_email
  before_create :create_activation_digest

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
                       length: { minimum: 6 },
                       allow_nil: true

  validates :password_confirmation, presence: true, unless: "password.blank?"

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

  def authenticated?(token, attribute)
    digest = send("#{attribute}_digest")
    return false if token.blank? || digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated:    true,
                   activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end
end
