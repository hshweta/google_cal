class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]

  def index
    if current_user
      Event.sync_events_from_google(current_user, GoogleCalendar::DEFAULT_CALANDER_ID) unless current_user.events.exists?
      @calendars = Event.get_calendar_list(current_user)
      @todays_events = Event.todays_events.group_by(&:google_calendar_id)
    end
  end
end
