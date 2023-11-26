class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :role, [:admin, :user]

  has_many :lendings, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :requests, dependent: :destroy
end
