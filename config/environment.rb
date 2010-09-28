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

# CISCO IP Phone
#The following code tells Rails to start a Ragi server as a separate thread.
#Dependencies.mechanism = :require
# Simple server that spawns a new thread for the server
#class SimpleThreadServer < WEBrick::SimpleServer
#     def SimpleThreadServer.start(&block)
#     Thread.new do block.call
#    end
#  end
#end
#require 'ragi/call_server'
#RAGI::CallServer.new(:ServerType => SimpleThreadServer)