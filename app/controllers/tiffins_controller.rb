class TiffinsController < ApplicationController
  before_action :set_customer
  before_action :set_tiffin, only: [ :update, :destroy]

  def index
    tiffins = @customer.tiffins
    total_tiffin_count = tiffins.sum(:status_count)
  
    render json: {
      tiffins: tiffins.map { |tiffin| tiffin.as_json.merge(start_date: tiffin.formatted_start_date) },
      total_count: total_tiffin_count
    }, status: :ok
  end

  def create
    tiffin = @customer.tiffins.new(tiffin_params)
    if tiffin.save
      render json: tiffin, status: :created
    else
      render json: { errors: tiffin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @tiffin.update(tiffin_params)
      render json: @tiffin, status: :ok
    else
      render json: { errors: @tiffin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tiffin.destroy
    render json: { message: 'Tiffin deleted successfully.' }, status: :ok
  end

  private

  def set_customer
    @customer = @current_user.customers.find_by(id: params[:customer_id])
    render json: { error: 'Customer not found' }, status: :not_found unless @customer
  end

  def set_tiffin
    @tiffin = @customer.tiffins.find_by(id: params[:id])
    render json: { error: 'Tiffin not found' }, status: :not_found unless @tiffin
  end

  def tiffin_params
    params.require(:tiffin).permit(:start_date, :date, :day_status, :night_status, :status_count)
  end

end
