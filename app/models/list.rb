class List < ActiveRecord::Base
  
  #Relationships
  has_many :collaborators
  has_many :users, :through => :collaborators
  has_many :tasks
  
  #Validations
  validates_presence_of :name
  validates_presence_of :description
  
end
