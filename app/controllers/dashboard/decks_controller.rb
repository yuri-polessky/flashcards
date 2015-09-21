class Dashboard::DecksController < DashboardController
  before_action :set_deck, except: [:index,:new,:create]
  
  def index
    @decks = current_user.decks
  end
  
  def show
  end

  def new
    @deck = current_user.decks.build
  end

  def create
    @deck = current_user.decks.build(deck_params)

    if @deck.save
      redirect_to decks_path, notice: t('.notice')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      redirect_to decks_path
    else
      render :edit
    end
  end

  def destroy
    @deck.destroy

    redirect_to decks_path
  end

  def set_current
    current_user.update(current_deck: @deck)
    redirect_to decks_path
  end

  private
    
  def set_deck
    @deck = current_user.decks.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end

end