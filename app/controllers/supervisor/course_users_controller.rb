class Supervisor::CourseUsersController < ApplicationController
  before_action :load_course

  def show
    @supervisors = User.supervisors
    @trainees = User.trainees
  end

  def update
    if @course.update course_users_params
      flash[:success] = t 'succesfully_enrolled'
      redirect_to [:supervisor, @course]
    else
      render :edit
    end
  end

  private
  def course_users_params
    params.require(:course).permit user_ids: []
  end

  def load_course
    @course = Course.find params[:course_id]
  end
end
