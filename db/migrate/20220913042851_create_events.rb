class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :venue
      t.string :google_event_id
      t.string :attendees
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
