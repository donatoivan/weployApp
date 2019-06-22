describe Timesheet do
  before(:all) do
    @timesheet = Timesheet.new(date: DateTime.new(2019, 04, 15, 0, 0, 0),
      start_time: DateTime.new(2019, 04, 15, 10, 0, 0), finish_time:  DateTime.new(2019, 04, 15, 17, 0, 0))
  end
  
  describe '.calculate_day' do
    it 'should return day of week' do
      expect(@timesheet.calculate_day).to eq("Monday")
    end
  end

  describe '.period' do
    it 'should provide a range between two given times as integers' do
      expect(@timesheet.period).to eq(1000..1700)
    end
  end

  describe '.add_amount' do
    it "returns method based on day of the week" do
      expect(@timesheet).to receive(:calculate_m_w_f)
      @timesheet.add_amount
    end
  end

  describe '.calculate_m_w_f' do
    it 'returns float as calculated wage based on hours' do
      expect(@timesheet.calculate_m_w_f).to eql(154.0)
    end
  end
end