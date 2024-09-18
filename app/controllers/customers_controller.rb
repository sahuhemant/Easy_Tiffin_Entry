class TiffinsController < ApplicationController
  before_action :set_customer

  def index
    @tiffins = @customer.tiffins
    render json: @tiffins
  end

  def create
    @tiffin = @customer.tiffins.new(tiffin_params)
    if @tiffin.save
      render json: @tiffin, status: :created
    else
      render json: { errors: @tiffin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Customer not found' }, status: :not_found
  end

  def tiffin_params
    params.require(:tiffin).permit(:start_date, :date, :day_status, :night_status, :status_count)
  end
end
