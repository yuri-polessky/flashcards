class CardsController < ApplicationController
  before_action :set_card, except: [:index,:new,:create]
  def index
    @cards = Card.all
  end
  
  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)

    if @card.save
      redirect_to cards_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      render 'edit'
    end
  end

  def destroy
    @card.destroy

    redirect_to cards_path
  end

  def review
    if @card.update(card_params)
      flash[:notice] = "Правильно"
    else
      flash[:notice] = "Неправильно"
    end
    redirect_to root_path
  end

  private
    
    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:original_text, :translated_text,:answer_original_text)
    end

end