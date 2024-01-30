class TasksController < ApplicationController
    before_action :authenticate_user!

    def index
        @search_by_title = params[:title_search]
        @search_by_date = params[:date_search]

        if @search_by_title
            @tasksCreated = Task.where("user_id = ? and title Like ?", current_user,  "%#{@search_by_title}%",)
        elsif  @search_by_date.present?
            begin
                parsed_search_by_date = Date.strptime(@search_by_date, '%Y-%m-%d')
                @tasksCreated = Task.where("user_id = ? and DATE(due_date) < ?", current_user, parsed_search_by_date)
            rescue ArgumentError
                Task.where("user_id = ?", current_user)
            end
        else
            @tasksCreated =  Task.where("user_id = ?", current_user)
        end
    end

    def show
        @task = Task.find_by(id: params[:id])
        @users = []
        @assign_user_table = AssignUserTable.find_by(task_id: params[:id])
        @assign_task_to_user_id = @assign_user_table&.user_id

        if params[:user_id] && !@assign_task_to_user_id && @task.status != 'Completed'
            @assign_task_to_user_id = params[:user_id]
            @assign_task = AssignUserTable.new(user_id: params[:user_id], task_id: params[:id])
            if @assign_task.save
              @assign_task_to_user_id = params[:user_id]
              redirect_to @task, notice: "Task assigned to user successfully"
            end
        elsif params[:user_id] && params[:id] && @task.status != 'Completed'
            @assign_user_table.update_column(:user_id, params[:user_id])
            @assign_task_to_user_id = params[:user_id]
        end
      
        User.all.each do |t1|
            @users << [t1.email, t1.id]
        end
      
        if params[:status]
            if params[:status] == 'Completed'
              @assign_user_table.update_column(:user_id, current_user.id)
              @assign_user_table = AssignUserTable.find_by(task_id: params[:id])
              @assign_task_to_user_id = @assign_user_table&.user_id
            end
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
            redirect_to new_task_path, notice: "#{@task.errors.full_messages.join(', ')}"
        end
    end

    def destroy
        @task = Task.find(params[:id])

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
                redirect_to edit_task_path , notice: " #{@task.errors.full_messages.join(', ')}"
            end
        else
            redirect_to root_path, notice: "Not a correct User"
        end
    end

    private
    def tasks_params
        params.require(:task).permit(:title, :description, :due_date, :status, :user_id)
    end
end