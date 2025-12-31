class ProfilesController < ApplicationController
  # POST /profiles
  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      render json: @profile, status: :created
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(
      :name,
      :birthday,
      :gender,
      :career_profile,
      :job_summary,
      :document_date
    )
  end
end

