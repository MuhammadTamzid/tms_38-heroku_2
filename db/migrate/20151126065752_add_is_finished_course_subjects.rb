class AddIsFinishedCourseSubjects < ActiveRecord::Migration
  def change
    add_column :course_subjects, :is_finished, :boolean, default: false
  end
end
