Spree::UserRegistrationsController.class_eval do
  def create
    @user = build_resource(spree_user_params)
    if resource.save
      if params[:wholesaler]
        @user.spree_roles << Spree::Role.find_or_create_by(name: "wholesaler")
      end

      set_flash_message(:notice, :signed_up)
      sign_in(:spree_user, @user)
      session[:spree_user_signup] = true
      associate_user
      sign_in_and_redirect(:spree_user, @user)
    else
      clean_up_passwords(resource)
      render :new
    end
  end
end
