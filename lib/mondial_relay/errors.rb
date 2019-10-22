# frozen_string_literal: true

module MondialRelay
  class Error < StandardError; end

  class ClientError < Error; end

  class TimeoutError < Error; end

  class EncodingError < Error; end

  class InvalidServiceError < Error; end

  class ResponseError < Error
    attr_reader :status, :body

    def initialize(status, body = nil)
      @status = status&.to_i
      @body = body
    end

    def message
      "#{status} - #{STATUS_CODES[status] || 'Unknown error'}"
    end
  end
end
