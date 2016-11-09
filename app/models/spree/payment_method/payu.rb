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

    def apply_adjustment(order)
      label = I18n.t(:charge_label, scope: :payu)

      order.adjustments.each { |a| a.destroy if a.label == label }
      order.adjustments.create!(
        amount: compute_charge.call(order),
        label: label,
        order: order
      )
      order.update!
    end

    def compute_commission(order)
      compute_charge.call(order)
    end

    private

    def compute_charge
      Rails.application.config.payu_charge if defined?(Rails)
    end
  end
end
