class Subject < ActiveRecord::Base
  include PrettyUrl

  has_many :user_subjects
  has_many :users, through: :user_subjects
  has_many :course_subjects
  has_many :courses, through: :course_subjects
  has_many :tasks, dependent: :destroy, inverse_of: :subject

  validates :name, presence: true,
                   length: { maximum: 20 },
                   uniqueness: {case_sensitive: false}
  validates :description, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :tasks, allow_destroy: true,
    reject_if: proc {|a| a[:name].blank?},
    reject_if: proc {|a| a[:description].blank?}

  class << self
    def to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |subject|
          csv << subject.attributes.values_at(*column_names)
        end
      end
    end
  end
end
