class Article < ApplicationRecord

  validates :headline, :content, :weblink, presence: true

  # User and Articles relatioship
  belongs_to :user

  # User and Comments relatioship
  has_many :comments

  # The Search feature, is working by comparing value entered to values of headline and content.
  def self.search(search)
    if search

      where(["headline LIKE ?", "% #{search}%"])
      where(["content LIKE ?", "% #{search}%"])

    else
      all
    end
  end
end
