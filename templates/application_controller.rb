class ApplicationController < ActionController::Base
  protect_from_forgery

  enable_authorization unless: :devise_controller? do |exception|
    logger.info "authorization disallowed #{exception.action.inspect} on #{exception.subject.inspect}"
    render text: 'access denied', status: :forbidden
  end
end
