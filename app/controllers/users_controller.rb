class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "#{@user.name} registered successfully! Now you can login."
      redirect_to login_path
    else
      render :new
    end
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user
      session[:user_name] = user.name  # Store the user's name in the session
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
    params.require(:user).permit(:name, :user_name, :password)
  end
end
