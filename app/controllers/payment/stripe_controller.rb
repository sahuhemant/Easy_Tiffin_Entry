# app/controllers/api/stripe_controller.rb
module Payment
  class StripeController < ApplicationController
    before_action :set_customer

    def charge
      stripe_service = StripeService.new
      stripe_customer = stripe_service.find_or_create_customer(@customer)
      stripe_customer_id = stripe_customer.id

      card = stripe_service.create_stripe_customer_card(stripe_customer)

      charge = stripe_service.create_stripe_charges(params[:amount].to_i, stripe_customer_id, card.id, "Donation for Tiffin Service")

      render json: { success: true, charge: charge, customer_name: @customer.name, amount: params[:amount] }, status: :ok
    rescue Stripe::CardError => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end

    private

    def stripe_params
      params.permit(:card_number, :exp_month, :exp_year, :cvc, :amount)
    end

    def set_customer
      @customer = User.find_by(id: @current_user.id) 
    end
  end
end
