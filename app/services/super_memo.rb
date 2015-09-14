# This class implement algorithm SuperMemo2
# Link to full description http://www.supermemo.com/english/ol/sm2.htm
class SuperMemo
  attr_reader :efactor, :quality, :interval, :review_count, :review_date
  
  def initialize(efactor, quality, interval, review_count)
    @efactor = efactor
    @quality = quality
    @interval = interval
    @review_count = (quality < 3 ? 0 : review_count)
    process_data
  end

  def process_data
    @efactor = new_efactor
    @interval = new_interval
    @review_count = review_count + 1
    @review_date = Date.current + interval.days
  end

  private

  def new_efactor
    return efactor if quality < 3
    new_efactor = efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    [1.3, new_efactor].max
  end

  def new_interval
    case review_count
    when 0 then 1
    when 1 then 6
    else
      (interval * efactor).round
    end
  end
end