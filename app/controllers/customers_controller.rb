class CustomersController < ApplicationController
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = 'Customer created successfully!'
      redirect_to login_success_path
    else
      render :new
    end
  end

  def index
    @customers = Customer.all
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :mobile_no, :address)
  end
end
