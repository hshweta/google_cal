module GoogleCalendar
  extend ActiveSupport::Concern

  DEFAULT_CALANDER_ID = 'primary'

  class_methods do
    def get_calendar_list(user)
      JSON.parse(Net::HTTP.get(api_uri(ENV['GOOGLE_CALENDARLIST_URL']), auth_header(user)))
    end

    def get_events(user, calendar_id)
      JSON.parse(Net::HTTP.get(api_uri(ENV['GOOGLE_EVENTLIST_URL'], calendar_id), auth_header(user)))
    end



    # private

    def auth_header(user)
      {:Authorization => "Bearer #{user.token}",
       'Accept' => 'application/json',
       'Content-Type' => 'application/json'
      }
    end

    def api_uri(url, calendar_id=nil, event_id=nil)
      url = url.gsub('calendarId', calendar_id) if calendar_id
      url = url.gsub('eventId', event_id) if event_id
      URI(url)
    end
  end

  def create_google_event
    url = self.class.api_uri(ENV['GOOGLE_EVENT_INSERT_URL'], self.google_calendar_id)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url, self.class.auth_header(self.user))
    request.body = convert_to_gcal_event.to_json
    resp = http.request(request)
    g_event = JSON.parse(resp.body)
    self.update(google_event_id: g_event['id'])
  end

  def update_google_event
    url = self.class.api_uri(ENV['GOOGLE_EVENT_UPDATE_URL'], self.google_calendar_id, self.google_event_id)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(url, self.class.auth_header(self.user))
    request.body = convert_to_gcal_event.to_json
    http.request(request)
  end

  def delete_google_event
    url = self.class.api_uri(ENV['GOOGLE_EVENT_DELETE_URL'], self.google_calendar_id, self.google_event_id)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Delete.new(url, self.class.auth_header(self.user))
    http.request(request)
  end

  private

  def convert_to_gcal_event
    event = {
      summary: self.title,
      location: self.venue,
      description: self.description,
      start: {
        dateTime: self.start_date.to_datetime.to_s,
        timeZone: 'Asia/Tokyo',
      },
      end: {
        dateTime: self.end_date.to_datetime.to_s,
        timeZone: 'Asia/Tokyo',
      },
      organizer: {
        email: self.user.email,
        displayName: self.user.name
      },
      attendees: event_attendees,
      reminders: {
        use_default: false
      },
      sendNotifications: true,
      sendUpdates: 'all'
    }
  end

  def event_attendees
    return if self.attendees.blank?
    self.email_attendees.map {|guest| { email: guest, displayName: guest.split('@')[0], organizer: false }} << { email: self.user.email, displayName: self.user.name, organizer: true}
  end
end
