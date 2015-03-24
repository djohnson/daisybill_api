require 'rest-client'

module DaisybillApi
  module Data
    class Client
      class InternalServerError < Exception
      end

      class UnauthorizedError < Exception
      end

      attr_reader :response, :request

      def initialize(method, path, params = {})
        DaisybillApi.logger.info "#{method.to_s.upcase} #{path}"
        DaisybillApi.logger.debug params.inspect
        url = DaisybillApi::Data::Url.build(path).to_s
        data = {
          method: method,
          url: url,
          payload: params.to_json,
          headers: { 'Content-Type' => 'application/json' }
        }
        RestClient::Request.execute(data) { |response, request, status|
          @response = JSON.parse response
          @request = request
          @status = status
          DaisybillApi.logger.info "Response status #{self.status}"
          DaisybillApi.logger.debug @response.inspect
        }
      end

      def status
        @status.code
      end

      def success?
        status == '200' || status == '201'
      end

      def bad_request?
        status == '400'
      end

      def unauthorized?
        status == '401'
      end

      def not_found?
        status == '404'
      end

      def error?
        status == '500'
      end
    end
  end
end