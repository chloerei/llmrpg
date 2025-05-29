class PersonasController < ApplicationController
  before_action :set_persona, only: %i[ show edit update destroy ]

  def index
    @personas = Current.user.personas.order(id: :desc)
  end

  def show
  end

  def new
    @persona = Persona.new
  end

  def edit
  end

  def create
    @persona = Current.user.personas.new(persona_params)

    if @persona.save
      redirect_to @persona, notice: "Persona was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @persona.update(persona_params)
      redirect_to @persona, notice: "Persona was successfully updated."
    else
      render :edit, status: :unprocessable_entity
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @persona.destroy!

    redirect_to personas_path, status: :see_other, notice: "Persona was successfully destroyed."
  end

  private

  def set_persona
    @persona = Current.user.personas.find(params.expect(:id))
  end

  def persona_params
    params.expect(persona: [ :avatar, :name, :description ])
  end
end
