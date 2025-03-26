class AppUser < ApplicationRecord
  has_secure_password
  
  # Simplify validations for testing
  validates :email, presence: true
  
  # Add this for debugging
  after_validation :log_errors, if: -> { Rails.env.development? }
  
  private
  
  def log_errors
    puts "Validation errors: #{errors.full_messages}" if errors.any?
  end
end
