class Comment < ApplicationRecord

  validates :details, presence: true

  belongs_to :article
  belongs_to :user
end
