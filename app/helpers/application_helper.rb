module ApplicationHelper  
  def bid_time_step_to_s(step)
    Time.at(step).strftime("%M:%S")
  end

  def bid_time_step_for_select
    bid_time_steps.map { |step| [bid_time_step_to_s(step), step] }
  end

  def status_desc_with(auction, &time_span_to_s)
    if not auction.started?
      t('auctions.index.start_in', delta: time_span_to_s.call(Time.now, auction.start_time))
    elsif auction.finished?
      t('auctions.index.finished_in', delta: time_span_to_s.call(auction.finish_time, Time.now))
    else
      t('auctions.index.finish_in', delta: time_span_to_s.call(Time.now, auction.finish_time))
    end
  end

  def status_desc(auction)
    status_desc_with(auction) { |from, to| distance_of_time_in_words(from, to) }
  end

  def status_desc_simple(auction)
    status_desc_with(auction) do |from, to|
      delta = to - from
      Time.at(delta).strftime("%M:%S")
    end
  end

  private

  def bid_time_steps
    [30, 60, 120]
  end
end
