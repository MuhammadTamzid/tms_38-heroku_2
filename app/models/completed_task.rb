class CompletedTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_subject
  belongs_to :task

  scope :filter_by_user, ->user{where user_id: user.id}

  after_save :create_task_finished_activity_log,
             :create_subject_completed_activity_log

  private
  def create_task_finished_activity_log
    Activity.create_activity_log user_id, user_subject.course.id, :task_finished,
      task_id, Task.find(task_id), user_subject.id
  end

  def create_subject_completed_activity_log
    if self.user_subject.completed?
        Activity.create_activity_log self.user.id, self.user_subject.course.id,
          :subject_completed, self.user_subject.subject.id,
          Subject.find(self.user_subject.subject.id),
          self.user_subject.id
    end
  end
end
