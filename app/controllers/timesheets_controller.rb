class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end
  
  def create
    @timesheet = Timesheet.new(timesheet_params)
    if @timesheet.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
  def timesheet_params
    params.require(:timesheet).permit(:date, :start_time, :finish_time)
  end
end
