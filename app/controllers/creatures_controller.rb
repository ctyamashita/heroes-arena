class CreaturesController < ApplicationController
  def index
    @creature = Creature.new
    if params[:class]
      @class = params[:class]
      @creatures = Creature.where(hero_class: params[:class])
    else
      @creatures = Creature.all
    end
    render :index
  end

  def show
    @player = Creature.find(params[:id])
    @hp = hp_display
    @exp = exp_display
    @battle = Battle.new
    @creature = Creature.new
  end

  def new
    @creature = Creature.new
  end

  def create
    @creature = Creature.new(creature_params)
    @creature.set_hp
    if @creature.save
      redirect_to creature_path(@creature)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @creature = Creature.find(params[:id])
    @creature.destroy
    redirect_to creatures_path
  end

  def edit
    @player = Creature.find(params[:creature_id])
    @enemy = Creature.find(params[:id])
    @battle = Battle.find(params[:battle_id])
  end

  def update
    @player = Creature.find(params[:creature_id])
    @enemy = Creature.find(params[:id])
    @battle = Battle.find(params[:battle_id])
    raise
  end

  private

  def creature_params
    params.require(:creature).permit(:name, :hero_class, :atk, :def, :spd, :dex, :int, :luk)
  end

  def hp_display
    hp_lost = @player.max_hp - @player.hp
    @hp = (('♥️' * @player.hp) + ('🤍' * hp_lost)).chars
    @hp.values_at(* @hp.each_index.select(&:even?)).join
  end

  def exp_display
    half = if @player.exp.digits.first == 5
             '🌓🌕'
           elsif @player.exp.digits.first < 5
             '🌕🌕'
           else
             '🌑'
           end
    ('🌑' * (@player.exp / 10)) + half + ('🌕' * (((100 - @player.exp) / 10) - 1))
  end
end
