class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    redirection = root_url

    if !user
      flash[:danger] = "Unknown user #{params[:email]}"
    elsif user.activated?
      flash[:warning] = "User #{params[:email]} has already been activated."
      redirection = login_url
    elsif user && user.authenticated?(params[:id], :activation)
      user.activate

      log_in user

      flash[:success] = "Account activated!"
      redirection = user
    else
      flash[:danger] = "Invalid activation link"
    end

    redirect_to redirection
  end
end
