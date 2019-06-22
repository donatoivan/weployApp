require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  before(:all) do
   @timesheet = Timesheet.new(date: DateTime.now,
                      start_time: DateTime.now, finish_time: DateTime.now + 7.hours)
  end

  it "is valid with valid attributes" do
    expect(@timesheet).to be_valid
  end

  it "is not valid with a future date" do
    @timesheet.date = DateTime.now + 7.days
    expect(@timesheet).to_not be_valid
  end

  it "is not valid with a finish time earlier than start time" do
    @timesheet.finish_time = @timesheet.start_time - 7.hours
    expect(@timesheet).to_not be_valid
  end

  it "is not valid without a date" do 
    @timesheet.date = nil
    expect(@timesheet).to_not be_valid
  end

  it "is not valid without a start time" do 
    @timesheet.start_time = nil
    expect(@timesheet).to_not be_valid
  end

  it "is not valid without a start time" do 
    @timesheet.finish_time = nil
    expect(@timesheet).to_not be_valid
  end
end
