# frozen_string_literal: true

require 'logger'

module ActiveCampaign
  LOGGER = ::Logger.new(STDOUT)
  module Faraday
    module Middleware
      #
      # Gem specific response middleware for Faraday
      #
      # @author Mikael Henriksson <mikael@mhenrixon.com>
      #
      class Response < ::Faraday::Response::Middleware
        dependency 'oj'

        include TransformHash

        # Override this to modify the environment after the response has finished.
        # Calls the `parse` method if defined
        def on_complete(env)
          env.body = parse(env.body)
        end

        def parse(body)
          return body if body.to_s.empty?

          body = ::Oj.load(body, mode: :compat)
          transform_keys(body, :underscore)
        end
      end
    end
  end
end
