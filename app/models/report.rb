class Report < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true,
                      uniqueness: {scope: :report_date}
  validates :report_date, presence: true
  validates :from_time, presence: true
  validates :to_time, presence: true
  validates :achievement, presence: true
  validates :next_day_plan, presence: true

  scope :latest, ->{order report_date: :desc}

  class << self
    def get_reports user_id, current_user
      if !user_id.nil?
        User.find(user_id).reports.latest
      else
        current_user.reports.latest
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |report|
          csv << report.attributes.values_at(*column_names)
        end
      end
    end
  end
end
