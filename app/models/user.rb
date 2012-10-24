class User < ActiveRecord::Base
  attr_accessible :active, :email, :first_name, :last_name, :password, :phone, :username
  
  validates :username, presence: true,
  										 uniqueness: true
  validates :password, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  
   before_save { |user| user.username = username.downcase }
end
