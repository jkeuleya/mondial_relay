# frozen_string_literal: true

require 'mondial_relay/version'
require 'mondial_relay/configuration'
require 'mondial_relay/errors'

require 'mondial_relay/status_codes'
require 'mondial_relay/security_code'
require 'mondial_relay/client'
require 'mondial_relay/sftp_client'
require 'mondial_relay/request'
require 'mondial_relay/query'
require 'mondial_relay/account'

require 'mondial_relay/operation'
require 'mondial_relay/translatable'
require 'mondial_relay/formattable'
require 'mondial_relay/has_defaults'

require 'mondial_relay/services'
require 'mondial_relay/service_registry'
require 'mondial_relay/services/base_service'
require 'mondial_relay/services/generic_service'
require 'mondial_relay/services/parcel_shops_service'

require 'mondial_relay/parcel_shops/search'
require 'mondial_relay/parcel_shops/search/format_params'
require 'mondial_relay/parcel_shops/search/format_response'
require 'mondial_relay/parcel_shops/search/translations'
require 'mondial_relay/parcel_shops/search/defaults'

require 'mondial_relay/parcel_shops/fetch_all'
require 'mondial_relay/parcel_shops/fetch_all/parse_line'

require 'mondial_relay/labels/create'
require 'mondial_relay/labels/create/translations'
require 'mondial_relay/labels/create/defaults'

require 'mondial_relay/labels/fetch'
require 'mondial_relay/labels/fetch/translations'
require 'mondial_relay/labels/fetch/defaults'

require 'mondial_relay/shipments/create'
require 'mondial_relay/shipments/create/translations'
require 'mondial_relay/shipments/create/defaults'

require 'mondial_relay/shipments/trace'
require 'mondial_relay/shipments/trace/translations'
require 'mondial_relay/shipments/trace/defaults'

module MondialRelay
  module_function

  def config
    @config ||= Configuration.new
  end

  def reset
    @config = Configuration.new
  end

  def configure
    yield(config)
    register_services
  end

  def services
    @services
  end

  def register_services
    @services = ServiceRegistry.new

    config.enabled_services.each do |service_name|
      @services.register(Services.build(service_name))
    end
  end

  def monitor(monitorable)
    return unless config.monitor.respond_to?(:call)
    config.monitor.call(monitorable)
  end

  def sftp_client
    @sftp_client ||= SftpClient.new
  end
end
