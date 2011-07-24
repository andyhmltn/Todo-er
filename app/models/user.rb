class User < ActiveRecord::Base
  has_many :collaborators
  has_many :lists, :through => :collaborators
  
  validates_presence_of :username
  
  attr_protected :password, :salt
  
  def self.make_salt()
    salt = rand(36**22).to_s(36)
    return salt
  end
  
  def self.salt(password="", salt="")
    salted = salt + password + salt + salt
    return salted
  end
  
  def self.hash(password="")
    BCrypt::Password.create(password)
  end
  
  def self.isValid?(username="", password="")
    @user = self.find_by_username(username)
    if @user == nil
      return false
    else
      ready_to_hash = self.salt(password, @user.salt)
      hashed = BCrypt::Password.new(@user.password)
      if hashed == ready_to_hash
        return @user
      else
        return false
      end
    end
  end
  
  def self.register(username="", password="")
    @user = self.create(:username => username)
    @user.salt = self.make_salt()
    @user.password = self.hash(self.salt(password, @user.salt))
    return @user.save
  end
end
