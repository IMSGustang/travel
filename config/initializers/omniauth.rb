Rails.application.config.middleware.use OmniAuth::Builder do
  #OmniAuth.config.full_host = 'http://localhost:3001'
  OmniAuth.config.full_host = Rails.env.production? ? 'http://abutours.com' : 'http://rails.abutours.com'
  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }
  
  provider :facebook, "123606161664428", "34d28a5b47886be9dfd16ee679e9a7ef"
  provider :google_oauth2, "614724567950-uld87gih4qtld02e7o1o15l1trsdso16.apps.googleusercontent.com", "-JXczCoH9R5uqWb4xCQSYPBI", {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end