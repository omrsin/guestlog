class Guest < ActiveRecord::Base
  attr_accessible :first_name, :id_document, :last_name
  
  has_many :visits
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :id_document, presence: true
end
