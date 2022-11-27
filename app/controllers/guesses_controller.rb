class GuessesController < ApplicationController
  def show
    set_spell
    if @spell.blank?
      session[:beat_ids] = []
      set_spell
    end

    session[:beat_ids] ||= []
    session[:spellname] = @spell.name.upcase
    session[:spell_id] = @spell.id
  end

  def win
    session[:beat_ids] << params[:spell_id]
    head :ok
  end

  private

  def set_spell
    @spell = Spell.where(
      id: Spell.where.not(id: session[:beat_ids])
               .pluck(:id).sample
    ).first
  end
end
