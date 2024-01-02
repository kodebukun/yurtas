class ManualsController < ApplicationController
  def index
    #incidentの未読があるか判別
    unreads = @current_user.unreads.where.not(incident_id: nil)
    if unreads.present?
      unreads.each do |unread|
        if unread.incident_id.present?
          @unread_incident = true
        end
      end
    end
  end
end
