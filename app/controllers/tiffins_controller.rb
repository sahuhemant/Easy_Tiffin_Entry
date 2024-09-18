class TiffinsController < ApplicationController
  before_action :set_customer

  def index
    @tiffins = @customer.tiffins
    @total_tiffin_count = @customer.tiffins.sum(:status_count) # Sum up the status_count

    render json: {
      tiffins: @tiffins,
      total_count: @total_tiffin_count
    }
  end

  def create
    @tiffin = @customer.tiffins.new(tiffin_params)
    
    if @tiffin.save
      render json: @tiffin, status: :created
    else
      render json: @tiffin.errors, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def tiffin_params
    params.require(:tiffin).permit(:start_date, :day_status, :night_status)
  end
end
