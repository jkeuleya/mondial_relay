# frozen_string_literal: true

module MondialRelay
  class Query
    attr_reader :service, :operation, :account, :params

    def self.run(service, operation, account, params)
      new(service, operation, account, params).execute!
    end

    def initialize(service, operation, account, params)
      @service = service
      @operation = operation
      @account = account
      @params = params
    end

    def execute!
      result = response_body

      with_monitoring do
        return result if StatusCodes.success?(status)
        raise ResponseError.new(status, response.body)
      end
    end

    private

    def response_body
      @response_body ||= response.body.dig(response_key, result_key)
    end

    def response
      @response ||= service.client.call(request)
    end

    def request
      MondialRelay::Request.new(operation, account, params)
    end

    def response_key
      "#{operation}_response".to_sym
    end

    def result_key
      "#{operation}_result".to_sym
    end

    def status
      response_body[:stat]&.to_i
    end

    def with_monitoring
      MondialRelay.monitor(monitorable_data)
      yield
    end

    def monitorable_data
      {
        request: request,
        response_body: response_body,
        status: status,
      }
    end
  end
end
