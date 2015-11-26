class Course < ActiveRecord::Base
  include PrettyUrl

  has_many :course_users, dependent: :destroy, inverse_of: :course
  has_many :users, through: :course_users
  has_many :trainees, -> {trainees}, class_name: "User",
            through: :course_users
  has_many :supervisors, -> {supervisors}, class_name: "User",
            through: :course_users
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects
  has_many :user_subjects
  has_many :completed_tasks, through: :user_subjects
  has_many :tasks, through: :subjects
  has_many :activities

  validates :name, presence: true, length:{minimum: 3},
                                   uniqueness: {case_sensitive: false}
  validates :description, presence: true, length:{minimum: 10}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_check

  accepts_nested_attributes_for :course_subjects, allow_destroy: true

  scope :current_enrolled, ->{where "is_closed = ?", false}
  scope :latest, ->{order created_at: :desc}

  class << self
    def get_courses user_id, course_name
      if !user_id.nil? && !course_name.nil?
        User.find(user_id).courses.where('name LIKE ?', "%#{course_name.strip}%")
      elsif !user_id.nil?
        User.find(user_id).courses
      elsif !course_name.nil?
        Course.where('name LIKE ?', "%#{course_name.strip}%")
      else
        Course.all
      end
    end
  end

  def dates_check
    if start_date > end_date
      errors.add(:start_date, I18n.t("date_check_text"))
    end
  end

  def get_subjects_for_course
    course_subjects_hash = Hash.new
    course_subjects = self.course_subjects
    course_subjects.each do |course_subject|
      course_subjects_hash[course_subject.subject_id] = course_subject
    end
    subjects = Subject.all
    return_course_subjects = Array.new
    if subjects.present?
      subjects.each do |subject|
        if course_subjects_hash.has_key? subject.id
          course_subject = course_subjects_hash[subject.id]
        else
          course_subject = CourseSubject.new subject_id: subject.id
        end
        return_course_subjects << course_subject
      end
    end
    return_course_subjects
  end

  def finished? user
    completed_tasks = self.completed_tasks.filter_by_user user
    completed_tasks.count == self.tasks.count
  end

  def course_completed_percentage user
    completed_tasks = self.completed_tasks.filter_by_user user
    percent = self.tasks.count > 0 ?
      completed_tasks.count * 100 / self.tasks.count : 0
    percent.round(0)
  end

  def percent user
    completed_tasks = self.completed_tasks.filter_by_user user
    self.tasks.count > 0 ? completed_tasks.count * 100 / self.tasks.count : 0
  end
end
