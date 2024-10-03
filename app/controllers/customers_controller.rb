class CustomersController < ApplicationController

  def index
    @customers = @current_user.customers
    
    if @customers.empty?
      render json: { message: 'No customers found for this user.' }, status: :ok
    else
      render json: @customers, status: :ok
    end
  end
  

  def create
    @customer = @current_user.customers.new(customer_params)
    if @customer.save
      render json: @customer, status: :created
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @customer = @current_user.customers.find(params[:id])
    if @customer.update(customer_params)
      render json: @customer, status: :ok
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def customer_payment_detail
    status = params[:payment_status]

    if %w[yes no].include?(status)
      customers =  @current_user.customers.where(payment_status: Customer.payment_statuses[status])
      render json: customers, status: :ok
    else
      render json: { error: 'Invalid payment status' }, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :mobile_no, :address, :amount_paid, :amount_due, :payment_status)
  end
end
