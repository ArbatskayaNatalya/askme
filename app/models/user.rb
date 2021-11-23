require 'openssl'

class User < ApplicationRecord

  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  USERNAME_REGEXP = /\A\w+\z/
  USERNAME_MAX_LENGTH = 40

  attr_accessor :password

  has_many :questions

  before_validation :downcase_username_and_email
  before_save :encrypt_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :username, format: { with: USERNAME_REGEXP }, length: { maximum: USERNAME_MAX_LENGTH }
  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  def self.authenticate(email, password)
    user = find_by(email: email&.downcase!)

    return unless user.present?

    password_hash =
      User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

    return unless user.password_hash == password_hash
    user
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  private

  def downcase_username_and_email
    username&.downcase!
    email&.downcase!
  end

  def encrypt_password
    if self.password.present?

      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end
end
