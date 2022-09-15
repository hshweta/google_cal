module GoogleCalendar
  extend ActiveSupport::Concern

  DEFAULT_CALANDER_ID = 'primary'

  class_methods do
    def get_calendar_list(user)
      JSON.parse(Net::HTTP.get(URI(ENV['GOOGLE_CALENDARLIST_URL']), auth_header(user)))
    end

    def get_events(user, calendar_id)
      events_url = ENV['GOOGLE_EVENTLIST_URL'].gsub('calendarId', calendar_id)
      JSON.parse(Net::HTTP.get(URI(events_url), auth_header(user)))
    end

    private

    def auth_header(user)
      {:Authorization => "Bearer #{user.token}"}
    end
  end
end
