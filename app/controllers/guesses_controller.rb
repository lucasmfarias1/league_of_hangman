class GuessesController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :set_player

  def show
    session[:start_time] ||= Time.now

    return render_game_over if @player.beat_spells.count >= 648

    set_spell
  end

  def win
    BeatSpell.create(spell_id: params[:spell_id], player: @player)
    head :ok
  end

  def reset
    @player.beat_spells.destroy_all
    session[:start_time] = Time.now
    session.delete(:end_time)
    session.delete(:beat_ids)

    redirect_to guesses_path
  end

  private

  def set_spell
    @spell = Spell.where(
      id: Spell.where.not(id: @player.beat_spells.pluck(:spell_id))
               .pluck(:id).sample
    ).first
  end

  def render_game_over
    session[:end_time] ||= Time.now
    @time_to_complete = distance_of_time_in_words(session[:start_time], session[:end_time])
    render :game_over
  end

  def set_player
    @player = Player.find_by(id: session[:player_id]) || Player.create
    session[:player_id] = @player.id
  end
end
