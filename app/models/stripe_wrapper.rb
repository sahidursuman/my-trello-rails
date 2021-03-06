module StripeWrapper
  class Charge
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @message = options[:message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
        )

        new(response: response)
      rescue Stripe::CardError => e
        new(message: e.message)
      end
    end

    def successful?
      @response.present?
    end
  end

  class Customer
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @message = options[:message]
    end

    def self.create(options = {})
      begin
        response = options[:user].stripe_customer_id.present? ? update_customer(options) : create_customer(options)

        new(response: response)
      rescue Stripe::CardError => e
        new(message: e.message)
      end
    end

    def successful?
      @response.present?
    end

    def id
      @response[:id]
    end

    private

    def self.create_customer(options = {})
      Stripe::Customer.create(
        source: options[:stripe_token],
        email: options[:user].email
      )
    end

    def self.update_customer(options = {})
      cust = Stripe::Customer.retrieve options[:user].stripe_customer_id
      cust.source = options[:stripe_token] if options[:stripe_token]
      cust.save
    end
  end

  class Subscription
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @message = options[:message]
    end

    def self.create(options = {})
      begin
        response = options[:user].stripe_subscription_id.present? ? update_subscription(options) : create_subscription(options)

        new response: response
      rescue Stripe::CardError, Stripe::InvalidRequestError => e
        new message: e.message
      end
    end

    def self.retrieve(options = {})
      begin
        response = Stripe::Subscription.retrieve(options[:user].stripe_customer_id)

        new response: response
      rescue Stripe::InvalidRequestError => e
        new message: e.message
      end
    end

    def successful?
      @response.present?
    end

    def id
      @response.id
    end

    private

    def self.create_subscription(options = {})
      Stripe::Subscription.create(
        customer: options[:user].stripe_customer_id,
        plan: options[:plan].stripe_plan_id
      )
    end

    def self.update_subscription(options = {})
      subs = Stripe::Subscription.retrieve options[:user].stripe_subscription_id
      subs.plan = options[:plan].stripe_plan_id
      subs.save
    end
  end
end
