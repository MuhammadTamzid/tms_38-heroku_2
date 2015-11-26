class CourseUser < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  belongs_to :trainees, -> {trainees}, class_name: "User",
              foreign_key: "user_id"
  belongs_to :supervisors, -> {supervisors}, class_name: "User",
              foreign_key: "user_id"

  validates :course_id, uniqueness: {scope: :user_id}
  validate :enrolled_to_one_active_course_for_trainee

  scope :has_user, ->user{find_by user_id: user.id}

  after_save :enroll_user_to_subjects, :create_course_enrollment_activity_log
  after_destroy :delete_user_subjects, :create_course_removal_activity_log

  private
  def enroll_user_to_subjects
    course.course_subjects.each do |course_subject|
      user.user_subjects.create subject_id: course_subject.subject_id,
        course_id: course_id
    end
  end

  def delete_user_subjects
    course.user_subjects.search_by_user(user_id).delete_all
  end

  def enrolled_to_one_active_course_for_trainee
    user = User.find user_id
    if user.courses.current_enrolled.count > 0 && user.trainee?
      errors.add(user.name, "already enrolled to a active course")
    end
  end

  def create_course_enrollment_activity_log
    Activity.create_activity_log user_id, course_id, :course_enrollement,
      course_id, Course.find(course_id)
  end

  def create_course_removal_activity_log
    Activity.create_activity_log user_id, course_id, :course_removal,
      course_id, Course.find(course_id)
  end
end
