class Supervisor::UploadsController < ApplicationController
  def create
    begin
      import params[:file]
      flash[:success] = t 'CSV_success'
    rescue
      flash[:danger] = t 'failed'
    end
    redirect_to supervisor_users_path role: User::ROLE[:trainee]
  end

  private
  def import file
    CSV.foreach(file.path, headers: true) do |row|
      user = User.new row.to_hash
      user.attributes = {role: User::ROLE[:trainee]}
      user.save
    end
  end
end
