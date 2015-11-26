class ReportsController < ApplicationController
  before_action :load_report, except: [:index, :new, :create]

  def index
    @reports = Report.get_reports(params[:user_id], current_user)
                     .paginate page: params[:page],per_page: 30
    respond_to do |format|
      format.html
      format.csv { send_data @reports.to_csv, filename: "Reports.csv" }
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      flash[:success] = t 'report_create'
      redirect_to @report
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @report.update_attributes report_params
      flash[:success] = t 'report_update'
      redirect_to @report
    else
      render :edit
    end
  end

  private
  def report_params
    params.require(:report).permit :report_date, :from_time,
                    :to_time, :achievement, :next_day_plan, :free_comment
  end

  def load_report
    @report = Report.find params[:id]
  end
end
