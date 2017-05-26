Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPCHA_ASKMECLONE_PUBLIC_KEY']
  config.secret_key = ENV['RECAPCHA_ASKMECLONE_PRIVATE_KEY']
end