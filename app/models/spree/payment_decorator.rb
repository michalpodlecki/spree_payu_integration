module Spree
  Payment.class_eval do
    after_initialize :create_payment_adjustment

    private

    def create_payment_adjustment
      if payment_method && payment_method.respond_to?(:create_adjustment)
        payment_method.create_adjustment(self)
      end
    end
  end
end
