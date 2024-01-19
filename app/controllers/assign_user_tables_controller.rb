class AssignUserTablesController <  ApplicationController
    before_action :authenticate_user!

    def index
        @search_by_title = params[:title_search]
        @assignedTasks =  Task.includes(:user, :assign_user_table).where('assign_user_tables.user_id =? AND tasks.title LIKE ?', current_user.id, "%#{@search_by_title}%").pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")
        @assignedTasks = convertToMap @assignedTasks
    end

    def show
        @assignedTask =  Task.includes(:user, :assign_user_table).where('assign_user_tables.user_id =? AND assign_user_tables.id=?', current_user.id, params[:id]).pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")

        puts @assignedTask.class
        @assignedTask = convertToMap @assignedTask

        if params[:status] && @assignedTask[0] && @assignedTask[0]['assign_to_user_id'] == current_user.id 
            @task = Task.find(@assignedTask[0]['task_id'])
            @task.update_column(:status, params[:status])
            @task_status = params[:status]
        else
            @assignedTask[0] ? @task_status = @assignedTask[0]['task_status'] : @task_status= nill
        end

    end

    private
    def convertToMap array
        return array.map do |id, task_id, task_title, task_description, task_due_date, task_status, assign_by_user_id, assign_by_user_email, assign_to_user_id|                
            {
                'id' => id,
                'task_title' => task_title,
                'task_id' => task_id,
                'task_description' => task_description, 
                'task_due_date' => task_due_date,
                'task_status' => task_status, 
                'assign_by_user_id' => assign_by_user_id, 
                'assign_by_user_email' => assign_by_user_email, 
                'assign_to_user_id' => assign_to_user_id
            }
        end
    end
end