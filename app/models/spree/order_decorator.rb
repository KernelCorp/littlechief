Spree::Order.class_eval do
  def payment_required?
    return false if user_id && Spree::User.find( user_id ).has_spree_role?('wholesaler')
    
    total.to_f > 0.0
  end
end
