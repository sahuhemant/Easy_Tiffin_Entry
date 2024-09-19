class TiffinsController < ApplicationController
  before_action :set_customer, only: [:index, :create, :update, :destroy]
  before_action :set_tiffin, only: [:update, :destroy]

  # def index
  #   @tiffins = @customer.tiffins
  #   ) @total_tiffin_count = @customer.tiffins.sum(:status_count# Sum up the status_count

  #   render json: {
  #     tiffins: @tiffins,
  #     total_count: @total_tiffin_count
  #   }
  # end
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

  def update
    if @tiffin.update(tiffin_params)
      render json: @tiffin
    else
      render json: { errors: @tiffin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tiffin.destroy
    head :no_content
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Customer not found' }, status: :not_found
  end

  def set_tiffin
    @tiffin = @customer.tiffins.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Tiffin not found' }, status: :not_found
  end

  def tiffin_params
    params.require(:tiffin).permit(:start_date, :date, :day_status, :night_status, :status_count)
  end
end
