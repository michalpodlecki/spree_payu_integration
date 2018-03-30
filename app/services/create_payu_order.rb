class CreatePayuOrder
  def initialize(order, payment_method, order_params)
    @order = order
    @payment_method = payment_method
    @order_params = order_params
  end

  def call
    build_payment
    choose_pos_id
    OpenPayU::Order.create(@order_params)
  end

  private

  def build_payment
    @payment = @order.payments.build(
      payment_method_id: @payment_method.id,
      amount: @order.total,
      state: 'checkout'
    )
  end

  def choose_pos_id
    credentials = Rails.application.config.payu_credentials.call(@order)
    OpenPayU::Configuration.merchant_pos_id = credentials[:merchant_pos_id]
    OpenPayU::Configuration.signature_key   = credentials[:signature_key]
  end
end
