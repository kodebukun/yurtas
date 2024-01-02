module IncidentsHelper
  def my_unreads_department_id(my_unreads, selected_department)
    my_unreads.each do |my_unread|
      if my_unread.incident.department.id == selected_department.id
          return selected_department.id
      end
    end
  end
end
