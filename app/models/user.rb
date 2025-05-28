class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :personas, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip }
end
