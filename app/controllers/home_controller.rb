class HomeController < ApplicationController
  def index
    redirect_to rooms_path
  end
end
