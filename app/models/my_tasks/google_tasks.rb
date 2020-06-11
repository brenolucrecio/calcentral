module MyTasks
  class GoogleTasks
    include MyTasks::TasksModule
    include Cache::UserCacheExpiry
    include ClassLogger

    def initialize(uid, starting_date)
      @uid = uid
      @starting_date = starting_date
      @now_time = Time.zone.now
    end

    def fetch_tasks
      logger.debug "Sorting Google tasks into buckets with starting_date #{@starting_date}"
      tasks = []

      google_proxy = GoogleApps::TasksList.new(user_id: @uid)
      google_proxy.tasks_list.items.each do |task|
        tasks << format_google_task_response(task) unless task.title.blank?
      end
      tasks.sort_by { |task| task['dueDate'].nil? ? 0 : task['dueDate']['epoch'] }
    end

    def return_response(response)
      if response && response.response.status == 200
        format_google_task_response response.data
      else
        logger.info "Errors in proxy response: #{response.inspect}"
        {}
      end
    end

    def update_task(params, task_list_id="@default")
      body = format_google_update_task_request params
      google_proxy = GoogleApps::UpdateTask.new(user_id: @uid)
      logger.debug "update_task where (task_list_id, task_id): {#{task_list_id}, #{params["id"]}}"
      return_response google_proxy.update_task(task_list_id, params["id"], body)
    end

    def insert_task(params, task_list_id="@default")
      body = format_google_insert_task_request params
      google_proxy = GoogleApps::InsertTask.new(user_id: @uid)
      logger.debug "insert_task where task_list_id: #{task_list_id}"
      return_response google_proxy.insert_task(task_list_id, body)
    end

    def clear_completed_tasks(task_list_id="@default")
      google_proxy = GoogleApps::ClearTaskList.new(user_id: @uid)
      logger.debug "clearing task list where task_list_id: #{task_list_id}"
      result = google_proxy.clear_task_list(task_list_id)
      {tasksCleared: result}
    end

    def delete_task(params, task_list_id="@default")
      google_proxy = GoogleApps::DeleteTask.new(user_id: @uid)
      logger.debug "delete_task where task_list_id: #{task_list_id}"
      response  = google_proxy.delete_task(task_list_id, params[:task_id])
      {task_deleted: response}
    end

    private

    def format_google_insert_task_request(entry)
      formatted_entry = entry.slice('title')
      if entry['dueDate'].present?
        formatted_entry['due'] = Date.strptime(entry['dueDate']).in_time_zone.to_datetime
      end
      formatted_entry['notes'] = entry['notes'] if entry['notes']
      formatted_entry
    end

    def format_google_delete_task_request(entry)
      entry.slice('id')
    end

    def format_google_update_task_request(entry)
      validate_google_params entry
      formatted_entry = entry.slice('id')
      formatted_entry['status'] = entry['status'] == 'needsAction' ? 'needsAction' : 'completed'
      formatted_entry['title'] = entry['title'] if entry['title'].present?
      formatted_entry['notes'] = entry['notes'] if entry['notes']
      if entry['dueDate'] && entry['dueDate']['dateTime']
        formatted_entry['due'] = Date.strptime(entry['dueDate']['dateTime']).in_time_zone.to_datetime
      end
      formatted_entry
    end

    def format_google_task_response(task)
      formatted_entry = {
        emitter: GoogleApps::Proxy::APP_ID,
        id: task.id,
        sourceUrl: task.self_link || '',
        title: task.title || '',
        type: 'task'
      }

      formatted_entry[:notes] = task.notes if task.notes
      formatted_entry[:status] = task.status == 'needsAction' ? 'needsAction' : 'completed'

      if task.completed
        format_date_into_entry!(convert_date(task.completed), formatted_entry, :completedDate)
      end

      due_date = if task.due
        # Google task datetimes have misleading datetime accuracy. There is no way to record a specific due time
        # for tasks (through the UI), thus the reported time+tz is always 00:00:00+0000. Calling convert_datetime_or_date
        # will strip off the false accuracy and return a plain old Date.
        parsed_date = convert_datetime_or_date task.due
        # Tasks are not overdue until the end of the day. Advance forward one day and back one second to cover
        # the possibility of daylight savings transitions.
        Time.at((parsed_date + 1).in_time_zone.to_datetime.to_i - 1).to_datetime
      end
      format_date_into_entry!(due_date, formatted_entry, :dueDate, true)

      formatted_entry[:bucket] = determine_bucket(due_date, formatted_entry, @now_time, @starting_date)
      logger.debug "Putting Google task with dueDate: #{formatted_entry[:dueDate]} in bucket: #{formatted_entry[:bucket]}"

      if formatted_entry[:bucket] == 'Unscheduled'
        format_date_into_entry!(convert_date(task.updated), formatted_entry, :updatedDate)
      end
      formatted_entry
    end

    def validate_google_params(params)
      # just need to make sure ID is non-blank, general_params caught the rest.
      google_filters = {'id' => 'noop, not a Proc type'}
      validate_params(params, google_filters)
    end
  end
end
