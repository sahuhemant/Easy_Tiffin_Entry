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

  def destroy
    @customer = @current_user.customers.find_by(id: params[:id])

    if @customer
      @customer.destroy
      render json: { message: 'Customer deleted successfully.' }, status: :ok
    else
      render json: { error: 'Customer not found.' }, status: :not_found
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

  def generate_today_tiffins
    today_date = Date.today
    @customers = @current_user.customers.includes(:tiffins)

    @customers.each do |customer|
      tiffin = customer.tiffins.find_or_create_by(date: today_date) do |t|
        t.start_date = today_date
        t.day_status = 0
        t.night_status = 0
        t.status_count = 0
      end
    end

    render json: { message: 'Tiffins for today created successfully.' }, status: :ok
  end

  def create_today_tiffins
    @customers = @current_user.customers.includes(:tiffins)
    today_date = Date.today

    # Fetching tiffins with today's date
    @tiffins_today = @customers.map do |customer|
      {
        customer: customer,
        tiffins: customer.tiffins.where(date: today_date)
      }
    end

    if @tiffins_today.empty?
      render json: { message: 'No tiffin updates found for today.' }, status: :ok
    else
      render json: @tiffins_today, status: :ok
    end
  end

  def update_today_tiffins
    today_date = Date.today
    tiffin_updates = params[:tiffins]

    tiffin_updates.each do |tiffin_data|
      customer_id = tiffin_data[:customer_id]
      tiffin = Tiffin.find_by(customer_id: customer_id, date: today_date)

      if tiffin
        tiffin.update(
          day_status: tiffin_data[:day_status],
          night_status: tiffin_data[:night_status],
          status_count: tiffin_data[:status_count]
        )
      end
    end
    render json: { message: 'Tiffin details updated successfully.' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end    

  private

  def customer_params
    params.require(:customer).permit(:name, :mobile_no, :address, :amount_paid, :amount_due, :payment_status)
  end
end
