class CustomersController < ApplicationController
  before_action :set_user

  def index
    @customers = @user.customers
    render json: @customers
  end

  def create
    @customer = @user.customers.new(customer_params)
    if @customer.save
      render json: @customer, status: :created
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(:name, :mobile_no, :address)
  end
end
