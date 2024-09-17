class CustomersController < ApplicationController
  def index
    @customers = Customer.all
    render json: @customers
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      render json: @customer, status: :created
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :mobile_no, :address)
  end
end
