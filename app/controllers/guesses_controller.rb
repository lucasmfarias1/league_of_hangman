class GuessesController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :set_player

  def show
    cookies[:start_time] ||= { :value => Time.now, :expires => 99.days.from_now }

    return render_game_over if @player.beat_spells.count >= 648

    set_spell
  end

  def win
    BeatSpell.create(spell_id: params[:spell_id], player: @player)
    head :ok
  end

  def reset
    @player.beat_spells.destroy_all
    cookies[:start_time] = Time.now
    cookies.delete(:end_time)

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
    cookies[:end_time] ||= { :value => Time.now, :expires => 99.days.from_now }
    @time_to_complete = distance_of_time_in_words(cookies[:start_time], cookies[:end_time])
    render :game_over
  end

  def set_player
    @player = Player.find_by(id: cookies[:player_id]) || Player.create
    cookies[:player_id] ||= { :value => @player.id, :expires => 99.days.from_now }
  end
end
