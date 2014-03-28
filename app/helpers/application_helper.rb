module ApplicationHelper
  def bid_time_step_to_s(step)
    Time.at(step).strftime("%M:%S")
  end

  def bid_time_step_for_select
    bid_time_steps.map { |step| [bid_time_step_to_s(step), step] }
  end

  def status_desc(auction)
    auction.status_desc
  end

  def timespan_to_s(seconds)
    Auction.timespan_to_s(seconds)
  end

  private

  def bid_time_steps
    [30, 60, 120]
  end
end
