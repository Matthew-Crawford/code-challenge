class User < ApplicationRecord
  before_create :generate_uuid

  has_secure_password

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
