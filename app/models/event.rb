class Event < ApplicationRecord
  include GoogleCalendar
  belongs_to :user

  validates :title, :description, :venue, :start_date, :end_date, presence: true
  validates_comparison_of :end_date, greater_than: :start_date

  scope :todays_events, -> { where("DATE(start_date) = ?", Date.today) }
  scope :by_calendar, -> (calenar_id){ where(google_calendar_id: calenar_id) }

  after_create :create_google_event
  after_update :update_google_event
  before_destroy :delete_google_event

  def email_attendees
    return if self.attendees.blank?
    attendees.split(", ")
  end

  def self.sync_events_from_google(user, calendar_id)
    events = get_events(user, calendar_id)
    return if events['items'].blank?
    events['items'].each do |e|
      event = find_by_google_event_id(e['id']) || new
      event.user = user
      event.google_calendar_id = calendar_id
      event.title = e['summary']
      event.description = e['summary']
      event.venue = e['location']
      event.google_event_id = e['id']
      event.start_date = e['start']['dateTime']
      event.end_date = e['end']['dateTime']
      event.save
    end
  end
end
