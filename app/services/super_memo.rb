class SuperMemo
  attr_reader :efactor, :quality, :interval, :review_count, :review_date
  attr_accessor :params
  
  def initialize(efactor, quality, interval, review_count)
    @efactor = efactor
    @quality = quality
    @interval = interval
    @review_count = (quality < 3 ? 0 : review_count)
    @params = {}
  end

  def get_new_params
    params[:efactor] = new_efactor
    params[:interval] = new_interval
    params[:review_count] = new_review_count
    params[:review_date] = Date.current + params[:interval].days
    params
  end

  private

  def new_efactor
    return efactor if quality < 3
    efactor = self.efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    [1.3, efactor].max
  end

  def new_interval
    case review_count
    when 0 then 1
    when 1 then 6
    else
      (interval * efactor).round
    end
  end

  def new_review_count
    review_count + 1
  end
end