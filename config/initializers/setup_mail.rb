ActionMailer::Base.smtp_settings = {
  :address              => "smtp.kion.it",
  :port                 => 25,
  :domain               => "kion.it",
  :user_name            => "asalicetti@kion.it",
  :password             => "abc123$%&",
  :authentication       => "login",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "ugov-ruby.kion.it"