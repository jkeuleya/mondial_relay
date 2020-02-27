# frozen_string_literal: true

require 'net/sftp'

module MondialRelay
  class SftpClient
    SFTP_PORT = 22

    def with_connection
      Net::SFTP.start(host, user, connection_options) do |conn|
        return yield(conn)
      end
    rescue Net::SFTP::Exception, Net::SSH::Exception => e
      raise MondialRelay::ClientError.new(e.message)
    end

    private

    def host
      config.sftp_host
    end

    def user
      config.sftp_user
    end

    def connection_options
      {
        timeout: connect_timeout,
        password: password,
        non_interactive: true,
        port: SFTP_PORT,
      }.compact
    end

    def connect_timeout
      config.sftp_connect_timeout
    end

    def password
      config.sftp_password
    end

    def config
      MondialRelay.config
    end
  end
end
