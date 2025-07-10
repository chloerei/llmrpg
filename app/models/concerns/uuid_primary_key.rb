module UuidPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid
  end

  def generate_uuid
    self.id = SecureRandom.uuid_v7
  end
end
