class AssignUserTablesController <  ApplicationController
    before_action :authenticate_user!

    def index
        @search_by_title = params[:title_search]
        @search_by_date = params[:date_search]

        if @search_by_title
            @assignedTasks = Task.joins(:assign_user_table, :user).where('assign_user_tables.user_id =? AND tasks.title LIKE ?', current_user.id, @search_by_title).pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")
        elsif  @search_by_date.present?
            begin
                parsed_search_by_date = Date.strptime(@search_by_date, '%Y-%m-%d').strftime('%Y-%m-%d')
                Task.joins(:assign_user_table, :user).where('assign_user_tables.user_id =? and DATE(due_Date) < ', current_user.id, parsed_search_by_date).pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")
              rescue ArgumentError
                Task.joins(:assign_user_table, :user).where('assign_user_tables.user_id =?', current_user.id).pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")
             end
        else
            @assignedTasks =  Task.joins(:assign_user_table, :user).where('assign_user_tables.user_id =?', current_user.id).pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")
        end
        @assignedTasks = convertToMap @assignedTasks
    end

    def show
        @assignedTask =  Task.joins(:assign_user_table, :user).where('assign_user_tables.user_id =? AND assign_user_tables.id=?', current_user.id, params[:id]).pluck("assign_user_tables.id, tasks.id, tasks.title, tasks.description, tasks.due_date, tasks.status, users.id, users.email, assign_user_tables.user_id")
        @assignedTask = convertToMap @assignedTask
        @assignedTask = @assignedTask&.first

        if params[:status] && @assignedTask && @assignedTask['assign_to_user_id'] == current_user.id 
            @task = Task.find(@assignedTask['task_id'])
            @assign_user_table = AssignUserTable.find_by(task_id: @assignedTask['task_id'])
            @task.update_column(:status, params[:status])
            if params[:status] == 'Completed'
                @assign_user_table.update_column(:user_id, @assignedTask['assign_by_user_id'])
                redirect_to assign_user_tables_path , notice: "status changed to completed"
            end
            @task_status = params[:status]
        # else
            # @assignedTask ? @task_status = @assignedTask['task_status'] : @task_status= nil
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