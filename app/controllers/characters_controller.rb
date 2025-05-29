class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show edit update destroy ]

  def index
    @characters = Current.user.characters.order(id: :desc)
  end

  def show
  end

  def new
    @character = Character.new
  end

  def edit
  end

  def create
    @character = Current.user.characters.new(character_params)

    if @character.save
      redirect_to @character, notice: "Character was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @character.update(character_params)
      redirect_to @character, notice: "Character was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy!

    redirect_to characters_path, status: :see_other, notice: "Character was successfully destroyed."
  end

  private
  def set_character
    @character = Character.find(params.expect(:id))
  end

  def character_params
    params.expect(character: [ :name, :description ])
  end
end
