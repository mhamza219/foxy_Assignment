class FileUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  # after_create :generate_public_token





  private

  def generate_public_token
    self.public_token = SecureRandom.urlsafe_base64(10)
  end


end
