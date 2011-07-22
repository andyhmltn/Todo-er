class ListsController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:login, :verify, :logout, :register, :create_user]
  
  def login
    @user = User.new
  end
  
  def verify
    @user = User.isValid?(params[:username], params[:password])
    if @user
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect_to :action => 'index'
    else
      flash[:notice] = "Invalid username/password combination"
      redirect_to :action => 'login'
    end
  end
  
  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "Thanks for visiting!"
    redirect_to :action => 'login'
  end
  
  def index
    @user = User.find(session[:user_id])
    @lists = @user.lists.all
  end
  
  def new
    @list = List.new
  end
  
  def create
    @user = User.find(session[:user_id])
    @list = @user.lists.new(params[:list])
    if @list.save
      flash[:notice] = "List created."
      redirect_to(:action => "show", :id => @list.id)
    else
      flash[:notice] = "There was an error"
      redirect_to(:action => "index")
    end
  end
  
  def show
    @list = User.find(session[:user_id]).lists.find(params[:id])
    @task = @list.tasks.new()
  end
  
  def edit
    @list = User.find(session[:user_id]).lists.find(params[:id])
  end
  
  def delete
    User.find(session[:user_id]).lists.destroy(params[:id])
    flash[:notice] = "List deleted"
    redirect_to :action => 'index'
  end
  
  def update
    @list = User.find(session[:user_id]).lists.find(params[:id])
    if @list.update_attributes(params[:list])
      flash[:notice] = "List updated"
      redirect_to :action => 'index'
    else
      flash[:notice] = "There was an error!"
      redirect_to :action => 'index'
    end
  end
  
  def register
  end
  
  def create_user
    if User.register(params[:username], params[:password])
      flash[:notice] = "Registered succesfully"
      redirect_to :action => 'login'
    else
      flash[:notice] = "We're sorry. There was an error with that request. Please try again."
      redirect_to :action => 'register'
    end
  end
end
