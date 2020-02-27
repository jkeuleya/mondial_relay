# frozen_string_literal: true

module MondialRelay
  class Configuration
    DEFAULT_SERVICES = %i(
      generic
      parcel_shops
    ).freeze

    API_URL = 'http://www.mondialrelay.fr/webservice/'

    SFTP_HOST = 'sftp.mondialrelay.com'
    SFTP_RELAIS_PATH = '/depuismrelay/relais.txt'
    SFTP_CONNECT_TIMEOUT = 10

    attr_accessor :api_url, :api_timeout, :api_max_retries,
      :enabled_services, :debug, :monitor,
      :sftp_host, :sftp_password, :sftp_user, :sftp_connect_timeout,
      :sftp_relais_path

    attr_reader :http_adapter

    def initialize
      @api_url = API_URL

      @api_timeout = 10
      @api_max_retries = 2

      @enabled_services = DEFAULT_SERVICES

      @sftp_host = SFTP_HOST
      @sftp_relais_path = SFTP_RELAIS_PATH
      @sftp_connect_timeout = SFTP_CONNECT_TIMEOUT

      @debug = false
      @monitor = nil

      @http_adapter = :net_http
    end
  end
end
