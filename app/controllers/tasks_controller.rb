class TasksController < ApplicationController
  
  attr_accessor :complete
  def create
    @list = User.find(session[:user_id]).lists.find(params[:task][:list_id])
    @task = @list.tasks.new(params[:task])
    if @task.save
      flash[:notice] = "Task created"
      redirect_to :controller => 'lists', :action => 'show', :id => params[:task][:list_id]
    end
  end
  
  def complete
    @list = User.find(session[:user_id]).lists.find(params[:list_id])
    @task = @list.tasks.find(params[:id])
    @task.completed = true
    @task.save
    redirect_to list_url(@list)
  end
end
