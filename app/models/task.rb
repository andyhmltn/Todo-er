class Task < ActiveRecord::Base
  
  #Relations
  belongs_to :list
  
  #Validations
  validates_presence_of :description
  
  #Scopes
  scope :complete, where(:completed => true)
  scope :incomplete, where(:completed => false)
  
end
