class MatchDataJob < Struct.new(:match_id_ours)

  def perform
    match = Match.find_by_id(match_id_ours)
    if match.present? && match.processed.blank?
      match.process_stats()
    end
  end

  def self.queue_time
    last_job = Delayed::Job.where("handler LIKE '%MatchDataJob%'").order("run_at DESC").first()
    if last_job.present?
      last_job.run_at + 5.seconds
    else
      DateTime.now().utc
    end
  end

  def error(job, exception)
    @exception = exception
  end

  def reschedule_at(attempts, time)
    if at_rate_limit?
      next_rate_limit_window
    end
  end

  def max_attempts
    if at_rate_limit?
      10
    else
      Delayed::Worker.max_attempts
    end
  end

  private

  def at_rate_limit?
    @exception.is_a?(Lol::TooManyRequests)
  end

  def next_rate_limit_window
    self.class.queue_time + 30.seconds
  end

end
