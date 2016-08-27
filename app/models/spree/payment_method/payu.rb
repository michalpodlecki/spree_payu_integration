module Spree
  class PaymentMethod::Payu < Spree::PaymentMethod
    def payment_profiles_supported?
      false
    end

    def cancel(*)
    end

    def source_required?
      false
    end

    def credit(*)
      self
    end

    def success?
      true
    end

    def authorization
      self
    end

    def create_adjustment(payment)
      return unless payment.new_record?

      compute_charge = Rails.application.config.payu_charge if defined?(Rails)

      payment.order.adjustments.create!(
        amount: compute_charge.call(payment.order),
        label: I18n.t(:charge_label, scope: :payu),
        order: payment.order
      )
    end
  end
end
