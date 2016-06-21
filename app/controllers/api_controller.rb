require 'pg'
require 'rest-client'
require 'json'
require 'slack-ruby-client'

class ApiController < ApplicationController

	skip_before_filter  :verify_authenticity_token

end
