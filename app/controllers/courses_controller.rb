class CoursesController < ApplicationController
  before_action :load_course, except: [:index]

  def index
    @courses = current_user.courses.current_enrolled
  end

  def show
    @supervisors = @course.supervisors
    @trainees = @course.trainees
    @subjects = @course.subjects
    @course_subjects = @course.user_subjects
    @user_subjects = @course.user_subjects
    @activities = @course.activities.latest.paginate page: params[:page],
      per_page: 10
  end

  private
  def load_course
    @course = current_user.courses.find params[:id]
  end
end
