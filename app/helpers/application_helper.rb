module ApplicationHelper  
  def bid_time_step_description(step)
    Time.at(step).strftime("%M:%S")
  end

  def bid_time_step_for_select
    bid_time_steps.map { |step| [bid_time_step_description(step), step] }
  end

  def status_desc(auction)
    if not auction.started?
      t('auctions.index.start_in', delta: distance_of_time_in_words(Time.now, auction.start_time))
    elsif auction.finished?
      t('auctions.index.finished_in', delta: distance_of_time_in_words(auction.finish_time, Time.now))
    else
      t('auctions.index.finish_in', delta: distance_of_time_in_words(Time.now, auction.finish_time))
    end
  end

  private

  def bid_time_steps
    [30, 60, 120]
  end
end
