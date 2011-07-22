class Task < ActiveRecord::Base
  
  belongs_to :list
  
  scope :complete, where(:completed => true)
  scope :incomplete, where(:completed => false)
end
