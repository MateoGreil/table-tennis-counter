class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/401.html", :status => 401, :layout => false
  end
end
