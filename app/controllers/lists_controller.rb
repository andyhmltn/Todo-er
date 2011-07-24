class ListsController < ApplicationController
  
  before_filter :confirm_logged_in, :except => [:login, :verify, :logout, :register, :create_user]
  
  def login
    if !session[:user_id].blank?
      redirect_to :action => 'index'
      return false
    end
    @user = User.new
  end
  
  def verify
    @user = User.isValid?(params[:username], params[:password])
    if @user
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect_to :action => 'index'
    else
      flash[:notice] = "Invalid username and/or password"
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
    @lists = @user.lists.find(:all, :order => "created_at DESC")
  end
  
  def new
    @list = List.new
  end
  
  def create
    @user = User.find(session[:user_id])
    @list = @user.lists.create(params[:list])
    if @list
      flash[:notice] = "List created."
      redirect_to(:action => "show", :id => @list.id)
    else
      flash[:notice] = "There was an error with that request. Please try again"
      redirect_to(:action => "new")
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
    if Collaborator.where(:list_id => params[:id]).count('id') > 1
      @list = List.find(params[:id])
      @list.users.delete(User.find(session[:user_id]))
      flash[:notice] = "You removed yourself from that group list"
      redirect_to :action => 'index'
    else
      User.find(session[:user_id]).lists.destroy(params[:id])
      flash[:notice] = "List deleted"
      redirect_to :action => 'index'
    end
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
    if !session[:user_id].blank?
      redirect_to :action => 'index'
      return false
    end
  end
  
  def create_user
    if !session[:user_id].blank?
      redirect_to :action => 'index'
      return false
    end
    @user = User.find_by_username(params[:username])
    if @user == nil
      if User.register(params[:username], params[:password])
        flash[:notice] = "Registered succesfully"
        redirect_to :action => 'login'
      else
        flash[:notice] = "We're sorry. There was an error with that request. Please try again."
        redirect_to :action => 'register'
      end
    else
      flash[:notice] = "That username has already been taken. Sorry chap. Try another one"
      redirect_to :action => 'register'
    end
  end
  
  def create_collaborator
    @collaborator = User.find_by_username(params[:username])
    if @collaborator == nil
      flash[:notice] = "User #{params[:username]} does not appear to exist. Please check the name and retry"
      redirect_to :action => 'show', :id => params[:list_id]
    else
      query = @collaborator.lists << List.find(params[:list_id])
      if query
        flash[:notice] = "Collaborator added"
        redirect_to :action => 'show', :id => params[:list_id]
      else
        flash[:notice] = "Collaborator not added"
        redirect_to :action => 'show', :id => params[:list_id]
      end
    end
  end
  
end
