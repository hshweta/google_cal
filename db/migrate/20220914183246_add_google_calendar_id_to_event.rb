class AddGoogleCalendarIdToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :google_calendar_id, :string
  end
end
