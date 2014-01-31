module ApplicationHelper  
  def bid_time_step_description(step)
    Time.at(step).strftime("%M:%S")
  end

  def bid_time_step_for_select
    bid_time_steps.map { |step| [bid_time_step_description(step), step] }
  end

  private

  def bid_time_steps
    [30, 60, 120]
  end
end
