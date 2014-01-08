module Spree
  class Spree::Gateway::Robokassa < Spree::Gateway
    preference :login, :string
    preference :secret_first, :string
    preference :secret_second, :string

    def provider_class
      ActiveMerchant::Billing::Integrations::Robokassa
    end
  end
end
