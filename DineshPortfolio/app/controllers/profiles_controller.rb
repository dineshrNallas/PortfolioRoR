class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :update]
  
  def show
    # Your existing show code
  end
  
  def update
    respond_to do |format|
      begin
        if @profile.persisted?
          if @profile.update(profile_params)
            format.html { redirect_to profile_path, notice: "Profile was successfully updated." }
            format.json { render json: { success: true, profile: @profile } }
          else
            Rails.logger.error "Profile update failed: #{@profile.errors.full_messages}"
            format.html { render :show, status: :unprocessable_entity }
            format.json { render json: { success: false, errors: @profile.errors.full_messages }, status: :unprocessable_entity }
          end
        else
          @profile = Profile.new(profile_params)
          if @profile.save
            format.html { redirect_to profile_path, notice: "Profile was successfully created." }
            format.json { render json: { success: true, profile: @profile } }
          else
            Rails.logger.error "Profile creation failed: #{@profile.errors.full_messages}"
            format.html { render :show, status: :unprocessable_entity }
            format.json { render json: { success: false, errors: @profile.errors.full_messages }, status: :unprocessable_entity }
          end
        end
      rescue => e
        Rails.logger.error "Error in profile update: #{e.message}\n#{e.backtrace.join("\n")}"
        format.html { redirect_to profile_path, alert: "An error occurred while saving the profile." }
        format.json { render json: { success: false, errors: [e.message] }, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def set_profile
    @profile = Profile.first || Profile.new
  end
  
  def profile_params
    params.require(:profile).permit(:name, :title, :image_url, :biography)
  end
end
