class Task < ActiveRecord::Base
  belongs_to :subject, inverse_of: :tasks
  has_many :completed_tasks
  has_many :users, through: :completed_tasks
  has_many :user_subjects, through: :completed_tasks

  validates :name, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 50 }
  validates :task_order, presence: true, numericality: {only_integer: true,
                                         greater_than_or_equal_to: 0}
  validates :subject, presence: true

  scope :filter_by_subject, ->subject{where subject_id: subject.id}

  def finished? completed_tasks, user_subject
    completed_tasks.detect{|completed_task| completed_task.user_subject_id == user_subject.id &&
      completed_task.task_id == self.id}.present?
  end
end
