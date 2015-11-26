module UserSubjectsHelper
  def subject_completed_percentage user_subject
    percent = user_subject.subject.tasks.count > 0 ?
      user_subject.completed_tasks.count * 100 / user_subject.subject.tasks.count : 0
    percent.round(0)
  end
end
