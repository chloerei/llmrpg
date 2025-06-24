class Room < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :characters, through: :members
  has_many :conversations, dependent: :destroy

  def character_list
    character_ids.join(',')
  end

  def character_list=(ids)
    self.character_ids = user.characters.where(id: ids.split(',').map(&:strip)).pluck(:id)
  end
end
