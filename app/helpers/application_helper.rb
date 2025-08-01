module ApplicationHelper
  include Pagy::Frontend

  def character_avatar_url(character)
    if character.avatar.attached?
      url_for(character.avatar.variant(:thumb))
    else
      asset_path("icon.png")
    end
  end
end
