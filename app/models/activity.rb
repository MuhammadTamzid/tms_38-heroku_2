class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :user_subject

  enum action_type: [:course_enrollement, :course_removal, :subject_completed,
                     :task_finished, :finish_subject_by_supervisor]

  scope :latest, ->{order created_at: :desc}

  class << self
    def create_activity_log user_id, course_id, action_type, target_id, target_object, user_subject_id = nil
      Activity.create user_id: user_id, course_id: course_id,
        user_subject_id: user_subject_id, action_type: action_type, target_id: target_id,
        action_message: target_object.name
    end
  end
end
