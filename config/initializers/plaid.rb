# frozen_string_literal: true
require 'plaid'

configuration = Plaid::Configuration.new
configuration.server_index = Plaid::Configuration::Environment["sandbox"]
configuration.api_key["PLAID-CLIENT-ID"] = Rails.application.credentials.dig(:plaid, :client_id)
configuration.api_key["PLAID-SECRET"] = Rails.application.credentials.dig(:plaid, :secret)

api_client = Plaid::ApiClient.new(
  configuration
)

::PLAID_CLIENT = Plaid::PlaidApi.new(api_client)