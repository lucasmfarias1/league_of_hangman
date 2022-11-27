class GuessesController < ApplicationController
  before_action :validate_guess, only: [:create]

  def show
    @spell = Spell.where(
      id: Spell.where.not(id: session[:beat_ids])
               .pluck(:id).sample
    ).first

    session[:beat_ids] ||= []
    session[:guesses] = []
    session[:correct_guesses] = 0
    session[:spellname] = @spell.name.upcase
    session[:spell_id] = @spell.id
  end

  def create
    if session[:guesses].include? guess
      render :create_failure
    else
      session[:guesses] << guess
      if session[:spellname].include?(guess)
        session[:correct_guesses] += 1

        if name_complete
          session[:beat_ids] << session[:spell_id]
          render :create_win
        else
          render :create_success
        end
      else
        render :create_failure
      end
    end
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
end
