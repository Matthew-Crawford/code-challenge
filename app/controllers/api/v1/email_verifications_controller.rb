class Api::V1::EmailVerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_verification, only: [:show, :destroy]
  before_action :authenticate


  # POST /email_verifications
  # can accept an array of up to 10 email address to validate
  def create
    verified_params = email_verification_params

    @email_verifications = []

    if verified_params["addresses"].length > 10 or verified_params["addresses"].length < 1
      render json:{ message: "Validation Failed", status: :bad_input }
      return
    end

    verified_params["addresses"].each do |address|
      email_verification = EmailVerification.new(address)
      unless email_verification.save
        render json: email_verification.errors, status: :unprocessable_entity
        return
      end
      @email_verifications << email_verification
    end
    render json: @email_verifications, status: :created, location: api_v1_email_verifications_url(@email_verification)
  end

  # GET /email_verifications
  def index
   @email_verifications = EmailVerification.all
   render json: @email_verifications
  end

  # GET /email_verifications/:id
  def show
    if @email_verification
      render json: @email_verification
    else
      render json: @email_verification, status: :not_found
    end
  end

  # DELETE /email_verifications/:id
  def destroy
    if @email_verification
      render json: @email_verification.destroy, status: :ok
    else
      render json: @email_verification, status: :not_found
    end
  end

  private

  def email_verification_params
    params.require(:email_verification).permit(:id, addresses: [:address])
  end

  def set_verification
   @email_verification = EmailVerification.where(id: params[:id]).first
  end
end
