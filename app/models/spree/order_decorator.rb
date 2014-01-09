Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :delivery, if: ->(order) { order.delivery_required? }
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end

  def delivery_required?
    !( user_id && Spree::User.find( user_id ).has_spree_role?('wholesaler') )
  end

  def payment_required?
    return false unless delivery_required?
    
    total.to_f > 0.0
  end
end
