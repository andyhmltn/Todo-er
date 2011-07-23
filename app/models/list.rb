class List < ActiveRecord::Base
  
  #Relationships
  belongs_to :user
  has_many :tasks
  
  #Validations
  validates_presence_of :name
  validates_presence_of :description
  
end
