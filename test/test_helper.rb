ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase

  fixtures :all
  include ApplicationHelper

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end

  def log_out_user
    session[:user_id] = nil
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  def log_out_user
    delete logout_path
  end

  def is_admin?(email: nil)
    if email
      User.find_by(email: email).admin?
    else
      User.find(session[:user_id]).admin?
    end
  end
end
