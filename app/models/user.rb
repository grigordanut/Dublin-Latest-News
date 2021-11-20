class User < ApplicationRecord

  extend Devise::Models

  # validates user name
  validates :name, presence: true

  # validates email
  # validates :email, presence: true
  # validates :email, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  # validates passsword
  # validates :password, presence: true

  # validates :password, length: {minimum: 6}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, :dependent => :destroy
  has_many :comments, :dependent => :destroy
end
