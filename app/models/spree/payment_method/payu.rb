module Spree
  class PaymentMethod::Payu < Spree::PaymentMethod
    def payment_profiles_supported?
      false
    end

    def cancel(*)
      simulated_successful_billing_response
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

      remove_charges(order)
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

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end
