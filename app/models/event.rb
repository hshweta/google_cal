class Event < ApplicationRecord
  belongs_to :user

  validates :title, :description, :venue, :start_date, :end_date, presence: true
  validates_comparison_of :end_date, greater_than: :start_date

end
