class ApplicationController < ActionController::Base
  protect_from_forgery

  #to have access to the SessionsHelper in the SessionController
  #(and not just in the sessions/views)
  include SessionsHelper
end
