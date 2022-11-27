class GuessesController < ApplicationController
  before_action :validate_guess, only: [:create]

  def show
    set_spell
    if @spell.blank?
      session[:beat_ids] = []
      set_spell
    end

    session[:beat_ids] ||= []
    session[:guesses] = []
    session[:correct_guesses] = 0
    session[:spellname] = @spell.name.upcase
    session[:spell_id] = @spell.id
  end

  def win
    session[:beat_ids] << params[:spell_id]
    render :win
  end

  private

  def validate_guess
    render :create_failure unless params[:guess].present? &&
                                  guess.length == 1 &&
                                  guess.match?(/[[:alpha:]]/)
  end

  def guess
    params[:guess].upcase
  end

  def name_complete
    session[:correct_guesses] >= session[:spellname].gsub(/[^a-z]/i, '').chars.uniq.size
  end

  def set_spell
    @spell = Spell.where(
      id: Spell.where.not(id: session[:beat_ids])
               .pluck(:id).sample
    ).first
  end
end
