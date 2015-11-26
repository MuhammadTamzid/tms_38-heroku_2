class UserSubjectsController < ApplicationController
  before_action :load_user_subject, only: [:update]

  def show
    @user_subject = UserSubject.find_by_user_id_and_course_id_and_subject_id params[:user_id], params[:course_id], params[:subject_id]
    @course = @user_subject.course
    @subject = @user_subject.subject
    @tasks = @subject.tasks
    @user_id = @user_subject.user_id
    @activities = @user_subject.activities.latest.paginate page: params[:page],
      per_page: 10
    @course_subject = CourseSubject.find_by_course_id_and_subject_id @course.id, @subject.id
    init_completed_tasks
  end

  def update
    if @user_subject.update task_params
      flash[:success] = t 'tasks_finished'
      redirect_to user_subject_path(user_id: @user_subject.user_id, course_id: @user_subject.course_id, subject_id: @user_subject.subject_id)
    else
      render :edit
    end
  end

  private
  def load_user_subject
    @user_subject = UserSubject.find params[:id]
  end

  def task_params
    params.require(:user_subject).permit completed_tasks_attributes: [:id,
      :user_id, :task_id]
  end

  def init_completed_tasks
    @tasks.each do |task|
      @user_subject.completed_tasks.find_or_initialize_by task_id: task.id,
        user_id: @user_id
    end
  end
end
