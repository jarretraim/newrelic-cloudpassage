
class HaloEvents
  attr_accessor :counts

  def initialize(events_array=nil)
    @log = Logger.new(STDOUT)
    @log.level = Logger::DEBUG

    # return 0 for any event count with no actual value
    @counts = Hash.new(0)

    unless events_array.nil?
      parse_events(events_array)
    end

  end

  def get_count(event_type)
    @counts[event_type]
  end

  private
  def parse_events(events_array)
    events_array.each do |event|
      @counts[event['type']] += 1
    end
  end
end