class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_secure_password

  validates :name, presence: true, length: {minimum: 6}
  validates :email, presence: true, uniqueness: true, format:{with: URI::MailTo::EMAIL_REGEXP}
  validates :password_digest, presence: true, length: {minimum: 4}
end