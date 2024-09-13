class UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'User registered successfully!'
    else
      render :new
    end
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user
      flash[:notice] = 'Login successful!'
      redirect_to login_success_path
    else
      flash.now[:alert] = 'Invalid username or password'
      render :login
    end
  end

  def login_success
    if params[:search].present?
      @customers = Customer.where('name LIKE ?', "%#{params[:search]}%")
    else
      @customers = Customer.all
    end
  end

  private

  def user_params
    params.permit(:name, :user_name, :password)
  end
end
