module ApplicationHelper  
  def bid_time_step_to_s(step)
    Time.at(step).strftime("%M:%S")
  end

  def bid_time_step_for_select
    bid_time_steps.map { |step| [bid_time_step_to_s(step), step] }
  end

  def status_desc_with(auction, &time_span_to_s)
    if not auction.started?
      t('auctions.index.start_in', delta: time_span_to_s.call(auction.start_in))
    elsif auction.finished?
      t('auctions.index.finished_in', delta: time_span_to_s.call(-auction.time_left))
    else
      t('auctions.index.finish_in', delta: time_span_to_s.call(auction.time_left))
    end
  end

  def status_desc(auction)
    status_desc_with(auction) do |delta|      
      timespan_to_s(delta)
    end
  end

  def timespan_to_s(seconds)    
    hours = seconds / 3600
    minutes = (seconds - hours*3600) / 60
    seconds = seconds % 60    
    '%02d:%02d:%02d' % [hours, minutes, seconds]
  end

  private

  def bid_time_steps
    [30, 60, 120]
  end
end
