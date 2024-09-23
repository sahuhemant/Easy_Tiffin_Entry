require 'stripe'

class StripeService
  def initialize()
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  def find_or_create_customer(customer)
    if customer.stripe_customer_id.present?
      stripe_customer = Stripe::Customer.retrieve(customer.stripe_customer_id)
    else
      stripe_customer = Stripe::Customer.create({
        name: customer.name,
        email: customer.email,
        phone: customer.number
        })
      customer.update_attribute(:stripe_customer_id, stripe_customer.id)
    end
    stripe_customer
  end

  def create_stripe_customer_card(stripe_customer)
    token = 'tok_visa' 
    card = Stripe::Customer.create_source(
      stripe_customer.id,
      { source: token }
    )
    card 
  end

  def create_stripe_charges(amount_to_be_paid, stripe_customer_id, card_id, xyz)
    Stripe::Charge.create({
      amount: amount_to_be_paid * 100,
      currency: 'usd',
      source: card_id,
      customer: stripe_customer_id,
      description:  "$#{amount_to_be_paid} charged for service"
    })
  end
end
