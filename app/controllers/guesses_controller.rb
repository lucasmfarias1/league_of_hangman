class GuessesController < ApplicationController
  include ActionView::Helpers::DateHelper

  def show
    session[:beat_ids] ||= []
    session[:start_time] ||= Time.now

    render_game_over if session[:beat_ids].count >= 648 #Spell.count

    set_spell
    session[:spellname] = @spell.name.upcase
    session[:spell_id] = @spell.id
  end

  def win
    session[:beat_ids] << params[:spell_id]
    head :ok
  end

  def reset
    session[:beat_ids] = []
    session[:start_time] = Time.now
    session.delete(:end_time)

    redirect_to guesses_path
  end

  private

  def set_spell
    @spell = Spell.where(
      id: Spell.where.not(id: session[:beat_ids])
               .pluck(:id).sample
    ).first
  end

  def render_game_over
    session[:end_time] ||= Time.now
    @time_to_complete = distance_of_time_in_words(session[:start_time], session[:end_time])
    render :game_over
  end
end
