class Supervisor::UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.search_by_course_id(params[:course_id]).send(params[:role].pluralize).paginate page: params[:page], per_page: 20
  end

  def show
    @activities = @user.activities.latest.paginate page: params[:page],
      per_page: 10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.attributes = {role: User::ROLE[:trainee]}
    if @user.save
      flash[:success] = t 'add_trainee_sucessful_message'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t 'update_profile_sucessful_message'
      redirect_to [:supervisor, @user]
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t 'delete_trainee_sucessful_message'
    redirect_to supervisor_users_path(role: User::ROLE[:trainee])
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :role, :password,
                                 :password_confirmation
  end

  # Before filters

  def load_user
    @user = User.find params[:id]
  end

   # Confirms the correct user.
  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user?(@user)
  end
end
