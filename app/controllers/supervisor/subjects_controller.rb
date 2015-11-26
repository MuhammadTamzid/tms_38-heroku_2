class Supervisor::SubjectsController < ApplicationController
  before_action :load_subject, except: [:index, :new, :create]

  def index
    @subjects = Subject.all.paginate page: params[:page], per_page: 10
    respond_to do |format|
      format.html
      format.csv { send_data @subjects.to_csv, filename: "Subjects.csv" }
    end
  end

  def show
    @tasks = @subject.tasks
  end

  def new
    @subject = Subject.new
    @subject.tasks.build
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t 'add_subject_sucessful_message'
      redirect_to [:supervisor, @subject]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t 'update_subject_sccessful_message'
      redirect_to [:supervisor, @subject]
    else
      render :edit
    end
  end

  def destroy
    @subject.destroy
    flash[:success] = t 'delete_subject_sucessful_message'
    redirect_to supervisor_subjects_url
  end

  private
  def subject_params
    params.require(:subject).permit :name, :description,
      tasks_attributes: [:id, :name, :description, :task_order, :_destroy]
  end

  def load_subject
    @subject = Subject.find params[:id]
  end
end
