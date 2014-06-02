Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
  address: "smtp.gmail.com", #this is your remote mail server, if you do not specify it rails will use 
  # mail server installed in your localhost
  port: 25, # the port at which mail server is running, for local host it is at 25
  domain: "example.com", # just giving a domain name to you smtp server, you can use any name
  authentication: "plain", # If your mail server requires authentication, you need to specify 
  # the authentication type here.This is a symbol and one of :plain, :login, :cram_md5.
  enable_starttls_auto: true,
  user_name: "lolwa92wright@gmail.com",
  password:  "sonu1mypassword"
  }


end
