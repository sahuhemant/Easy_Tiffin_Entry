class TiffinsController < ApplicationController
  before_action :set_customer, only: [:new, :create, :index, :edit, :update]

  def new
    @tiffin = @customer.tiffins.new
  end

  def create
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
    @total_tiffin = @customer.tiffins.sum(:status_count)

    @edit_tiffin_id = params[:edit_id] # Set this to the passed parameter to identify which row to edit
  end

  def edit
    @tiffins = @customer.tiffins
    @edit_tiffin_id = params[:id]  # Use the tiffin's ID to track the row being edited
    render :index  # Render the index view to show the inline edit form
  end

  def update
    @tiffin = @customer.tiffins.find(params[:id])
  
    if @tiffin.update(tiffin_params)
      redirect_to customer_tiffins_path(@customer), notice: 'Tiffin was successfully updated.'
    else
      @tiffins = @customer.tiffins
      @edit_tiffin_id = @tiffin.id  # Keep the edit mode active if the update fails
      render :index
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
