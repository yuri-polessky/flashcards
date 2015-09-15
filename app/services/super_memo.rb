# This class implement algorithm SuperMemo2
# Link to full description http://www.supermemo.com/english/ol/sm2.htm
class SuperMemo
  
  class << self
    
    def call(efactor, quality, interval, review_count)
      review_count = (quality < 3 ? 0 : review_count)
      old_interval = interval
      interval = new_interval(review_count, old_interval, efactor)
      { 
        efactor: new_efactor(quality, efactor),
        interval: interval,
        review_count: review_count + 1,
        review_date: Date.current + interval.days
      }
    end

    private

    def new_efactor(quality, efactor)
      return efactor if quality < 3
      new_efactor = efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
      [1.3, new_efactor].max
    end

    def new_interval(review_count, old_interval, efactor)
      case review_count
      when 0 then 1
      when 1 then 6
      else
        (old_interval * efactor).round
      end
    end
  end
end