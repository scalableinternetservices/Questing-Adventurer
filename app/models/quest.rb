class Quest < ActiveRecord::Base
  validates :questgiver, :title, :price, :description,
            :post_time, :expiration_time, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  
  belongs_to :adventurer, class_name: 'User', foreign_key: 'adventurer_id'
  belongs_to :questgiver, class_name: 'User', foreign_key: 'questgiver_id'

  has_many :pendings
  has_many :pending_adventurers, through: :pendings, class_name: 'User',
           source: :user, dependent: :destroy

  enum status: [ :open, :closed, :success, :failure ]

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :skills, :interests

	def self.search(search)
	  if search
      keywords = search.split(' ')
	    # where('title LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%")
      # Find users with any of the specified tags:
      Quest.tagged_with(keywords, :any => true)
	  else
	    all
	  end
	end

end
