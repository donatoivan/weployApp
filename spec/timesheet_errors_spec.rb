describe Timesheet do
  before(:all) do
    @timesheet = Timesheet.new(date: DateTime.new(2020, 04, 15, 0, 0, 0),
      start_time: DateTime.new(2019, 04, 15, 10, 0, 0), finish_time:  DateTime.new(2019, 04, 15, 8, 0, 0))
    @timesheet_saved = Timesheet.create(date: DateTime.new(2019, 04, 15, 0, 0, 0),
    start_time: DateTime.new(2019, 04, 15, 10, 0, 0), finish_time:  DateTime.new(2019, 04, 15, 17, 0, 0))
  end
  
  describe '.is_in_future' do
    it 'should return date in future error' do
      @timesheet.is_in_future
      expect(@timesheet.errors.messages[:date][0]).to eq("cannot be in the future")
    end
  end

  describe '.finish_before_start' do
    it 'should return finish earlier than start error' do
      @timesheet.finish_before_start
      expect(@timesheet.errors.messages[:finish_time][0]).to eq("cannot be before start time")
    end
  end

  describe '.timesheet_overlap' do
    it 'should return timesheet overlap error' do
      @timesheet2 = Timesheet.new(date: DateTime.new(2019, 04, 15, 0, 0, 0),
      start_time: DateTime.new(2019, 04, 15, 10, 0, 0), finish_time:  DateTime.new(2019, 04, 15, 17, 0, 0))

      @timesheet2.timesheet_overlap
      expect(@timesheet2.errors.messages[:timesheet][0]).to eq("overlaps with existing timesheet")
    end
  end
end