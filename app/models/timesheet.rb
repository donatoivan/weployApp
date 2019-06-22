class Timesheet < ApplicationRecord
  validates :date, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validate :is_in_future
  validate :finish_before_start
  validate :timesheet_overlap
  validate :add_amount

  
  def is_in_future
    return if self.date.nil?
    if self.date.to_datetime > DateTime.now
      errors.add(:date, 'cannot be in the future')
    end
  end

  def finish_before_start
    return if self.start_time.nil? || self.finish_time.nil?
    if self.finish_time < self.start_time
      errors.add(:finish_time, 'cannot be before start time')
    end
  end

  def period
    start_time.to_s(:time).split(":").join().to_i..finish_time.to_s(:time).split(":").join().to_i    
  end

  def timesheet_overlap
    other_timesheets = Timesheet.all
    is_overlapping = other_timesheets.any? do |other_timesheet|
      if self.date == other_timesheet.date
        period.overlaps?(other_timesheet.period)
      end
    end
    errors.add(:timesheet, "overlaps with existing timesheet") if is_overlapping
  end

  def calculate_m_w_f
    if start_time.to_s(:time).to_time >= "07:00".to_time && finish_time.to_s(:time).to_time <= "19:00".to_time
      #if start and finish time are within 7AM - 7PM
      self.amount = (((self.finish_time - self.start_time) / 60.0) / 60.0) * 22
    elsif start_time.to_s(:time).to_time < "07:00".to_time && finish_time.to_s(:time).to_time <= "19:00".to_time
      #if start time is before 7AM && finish time is before 7pm
      extra = ((("07:00".to_time - self.start_time.to_s(:time).to_time) / 60.0) / 60.0) * 33
      normal = (((self.finish_time.to_s(:time).to_time - "07:00".to_time) / 60.0) / 60.0) * 22
      self.amount = extra + normal
    elsif start_time.to_s(:time).to_time >= "07:00".to_time && finish_time.to_s(:time).to_time > "19:00".to_time
      #if start time is after or equal to 7AM && finish time is after 7PM
      extra = (((self.finish_time.to_s(:time).to_time - "19:00".to_time) / 60.0) / 60.0) * 33
      normal = ((("19:00".to_time - self.start_time.to_s(:time).to_time) / 60.0) / 60.0) * 22
      self.amount = extra + normal
    elsif start_time.to_s(:time).to_time < "07:00".to_time && finish_time.to_s(:time).to_time > "19:00".to_time
      #if start and finish are beyoind 7AM - 7PM
      extra_before = ((("07:00".to_time - self.start_time.to_s(:time).to_time) / 60.0) / 60.0) * 33
      extra_after = (((self.finish_time.to_s(:time).to_time - "19:00".to_time) / 60.0) / 60.0) * 33
      normal = ((("19:00".to_time - "07:00".to_time) / 60) / 60) * 22
      self.amount = extra_before + extra_after + normal
    end
  end

  def calculate_tue_thu
    if start_time.to_s(:time).to_time >= "05:00".to_time && finish_time.to_s(:time).to_time <= "17:00".to_time
      #if start and finish time are within 5AM - 5PM
      self.amount = (((self.finish_time - self.start_time) / 60.0) / 60.0) * 25
    elsif start_time.to_s(:time).to_time < "05:00".to_time && finish_time.to_s(:time).to_time <= "17:00".to_time
      #if start time is before 5AM && finish time is before 5pm
      extra = ((("05:00".to_time - self.start_time.to_s(:time).to_time) / 60.0) / 60.0) * 35
      normal = (((self.finish_time.to_s(:time).to_time - "05:00".to_time) / 60.0) / 60.0) * 25
      self.amount = extra + normal
    elsif start_time.to_s(:time).to_time >= "05:00".to_time && finish_time.to_s(:time).to_time > "17:00".to_time
      #if start time is after or equal to 5AM && finish time is after 5PM
      extra = (((self.finish_time.to_s(:time).to_time - "17:00".to_time) / 60.0) / 60.0) * 35
      normal = ((("17:00".to_time - self.start_time.to_s(:time).to_time) / 60.0) / 60.0) * 25
      self.amount = extra + normal
    elsif start_time.to_s(:time).to_time < "05:00".to_time && finish_time.to_s(:time).to_time > "17:00".to_time
      #if start and finish are beyoind 5AM - 5PM
      extra_before = ((("05:00".to_time - self.start_time.to_s(:time).to_time) / 60.0) / 60.0) * 35
      extra_after = (((self.finish_time.to_s(:time).to_time - "17:00".to_time) / 60.0) / 60.0) * 35
      normal = ((("17:00".to_time - "05:00".to_time) / 60) / 60) * 25
      self.amount = extra_before + extra_after + normal
    end
  end

  def calculate_weekend
    self.amount = (((self.finish_time - self.start_time) / 60.0) / 60.0) * 47
  end

  def calculate_day
    self.start_time.strftime("%A")
  end
  
  def add_amount
    return if self.date.nil?
    day = self.date.strftime("%A")
    if day == "Monday" || day == "Wednesday" || day == "Friday"
      calculate_m_w_f
    elsif day == "Tuesday" || day == "Thursday"
      calculate_tue_thu
    else
      calculate_weekend
    end
  end
end
