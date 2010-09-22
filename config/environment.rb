# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('../../lib/jquery_dropdown_helper', __FILE__)

# Aggiunto per il rendering dell'XML per dhtmlxGrid
#require 'active_support/builder' unless defined?(Builder)

# Initialize the rails application
Gs3::Application.initialize!

ActionMailer::Base.perform_deliveries = true # the "deliver_*" methods are available
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_content_type = "text/html" # default: "text/plain"
