class User < ApplicationRecord
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

  validates :password, confirmation: true,
                       presence: true,
                       length: { minimum: 6 }

  validates :password_confirmation, presence: true

  has_secure_password
end
