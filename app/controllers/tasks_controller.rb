class TasksController < ApplicationController
    before_action :authenticate_user!

    def index
        @search_by_title = params[:title_search]
        @tasksCreated = Task.where("user_id = ? and title Like ?", current_user,  "%#{@search_by_title}%")
    end

    def show
        @task = Task.find(params[:id])
        @users = []

        @assign_task_to_user_id = AssignUserTable.find_by(task_id: params[:id])&.user_id
        
        if params[:user_id] && params[:id] && !@assign_task_to_user_id
            @assign_task_to_user_id = params[:user_id]
            @assign_task = AssignUserTable.new(user_id: params[:user_id], task_id: params[:id])
            if @assign_task.save
                @assign_task_to_user_id = params[:user_id]
                redirect_to @task, notice: "Task assigned to user successfully"
            end
        else
            # redirect_to @task ,notice: "Task already assigned"
        end

        User.all.each do |t1|
            if t1.id != current_user.id
                @users << [t1.email,t1.id]
            end
        end

        if params[:status] 
            @task.update_column(:status, params[:status])
        end
    end

    def new
        @task = Task.new
    end

    def create
        @task = Task.new(tasks_params)
        if @task.save
            redirect_to @task, notice: "Task created sucessfully"
        else
            redirect_to new_task_path, notice: "Task could not be created"
        end
    end

    def destroy
        @task = Task.find(params[:id])

        puts @assign_user_task.inspect
        if @task.user_id == current_user.id
            @task.assign_user_table ? @task.assign_user_table.destroy : ""
            @task.destroy
            redirect_to root_path, notice: "Task destroyed successfully"
        else 
            redirect_to root_path, notice: "Not a correct User"
        end
    end

    def edit
        @task = Task.find(params[:id])
    end

    def update
        @task = Task.find(params[:id])

        if @task.user_id == current_user.id 
            if @task.update(tasks_params)
                redirect_to root_path,  notice: "Task updated successfully"
            else
                redirect_to root_path, notice: "Task could not be updated"
            end
        else
            redirect_to root_path, notice: "Not a correct User"
        end
    end

    

    private
    def tasks_params
        params.require(:task).permit(:title, :description, :due_date, :status, :user_id )
    end
end