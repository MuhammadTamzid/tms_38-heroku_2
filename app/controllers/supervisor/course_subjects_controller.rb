class Supervisor::CourseSubjectsController < ApplicationController
  before_action :load_course_subject, only: [:update]

  def show
    @course_subject = CourseSubject.find_by_course_id_and_subject_id params[:course_id], params[:subject_id]
    @course = @course_subject.course
    @subject = @course_subject.subject
    @tasks = @subject.tasks
    CourseSubject.set_current_supervisor current_user
  end

  def update
    if @course_subject.update_attributes is_finished: true
      flash[:success] = t 'subject_finished'
      redirect_to supervisor_course_subject_path(course_id: @course_subject.course_id,
        subject_id: @course_subject.subject_id)
    else
      render :edit
    end
  end

  private
  def load_course_subject
    @course_subject = CourseSubject.find params[:id]
  end
end
