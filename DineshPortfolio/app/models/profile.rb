class Profile < ApplicationRecord
  validates :name, presence: true
  
  # Add a method to handle base64 images
  def image_url=(data)
    # If it's a base64 string, process it
    if data.is_a?(String) && data.start_with?('data:image')
      # Store the base64 data directly
      super(data)
    else
      super
    end
  end
end
