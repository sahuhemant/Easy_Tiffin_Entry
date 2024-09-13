class TiffinsController < ApplicationController
  def new
    @customer = Customer.find(params[:customer_id])
    @tiffin = @customer.tiffins.new
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @tiffin = @customer.tiffins.new(tiffin_params)

    if @tiffin.save
      redirect_to customer_tiffins_path(@customer), notice: 'Tiffin was successfully created.'
    else
      render :new
    end
  end

  def index
    @customer = Customer.find(params[:customer_id])
    @tiffins = @customer.tiffins
  end

  private

  def tiffin_params
    params.require(:tiffin).permit(:start_date, :status)
  end
end
