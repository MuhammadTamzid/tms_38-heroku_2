class UserSubject < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  belongs_to :course
  has_many :completed_tasks
  has_many :tasks, through: :completed_tasks
  has_many :activities, dependent: :destroy

  validates :user_id, uniqueness: {scope: [:subject_id, :course_id]}

  scope :search_by_subject, ->subject_id{where subject_id: subject_id}
  scope :search_by_user, ->user_id{where user_id: user_id}

  accepts_nested_attributes_for :completed_tasks, allow_destroy: true,
    reject_if: proc{|a| a[:task_id] == "0"}

  class << self
    def find_by_user_id_and_course_id_and_subject_id user_id, course_id, subject_id
      UserSubject.find_by(user_id: user_id, course_id: course_id, subject_id: subject_id)
    end
  end

  def completed?
    self.subject.tasks.count == self.completed_tasks.count
  end
end
