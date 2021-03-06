# encoding: utf-8

class Guest < ActiveRecord::Base
  attr_accessible :first_name, :id_document, :last_name
  
  has_many :visits
  
  VALID_NAME_REGEX = /^[a-zA-ZáÁéÉíÍóÓúÚüÜñÑ]*$/i
  
  validates :first_name, presence: true, format: { with: VALID_NAME_REGEX }, length: { maximum: 20 }
  validates :last_name, presence: true, format: { with: VALID_NAME_REGEX }, length: { maximum: 20 }
  validates :id_document, presence: true, numericality: true, length: { maximum: 15 }
end
