class CourseSubject < ActiveRecord::Base
  belongs_to :course
  belongs_to :subject

  validates :course_id, uniqueness: {scope: :subject_id}

  after_save :enroll_subject_to_user
  after_update :create_finish_subject_by_supervisor_activity_log
  after_destroy :delete_subject_users

  class << self
    def find_by_course_id_and_subject_id course_id, subject_id
      CourseSubject.find_by(course_id: course_id, subject_id: subject_id)
    end

    def set_current_supervisor user
      @@current_supervisor = user
    end
  end

  private
  def enroll_subject_to_user
    course.course_users.each do |course_user|
      subject.user_subjects.create user_id: course_user.user_id,
        course_id: course_id
    end
  end

  def delete_subject_users
    course.user_subjects.search_by_subject(subject_id).delete_all
  end

  def create_finish_subject_by_supervisor_activity_log
    Activity.create_activity_log @@current_supervisor.id, self.course.id,
      :finish_subject_by_supervisor, self.subject.id, Subject.find(self.subject.id)
  end
end
