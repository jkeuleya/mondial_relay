# frozen_string_literal: true

module MondialRelay
  module ParcelShops
    class FetchAll
      include Interactor::Initializer

      FILENAME = 'relais.txt'

      def run
        MondialRelay.sftp_client.with_connection do |conn|
          Tempfile.create(FILENAME) do |file|
            conn.download!(relais_path, file.path)

            parse_file(file)
          end
        end
      end

      private

      def relais_path
        MondialRelay.config.sftp_relais_path
      end

      def parse_file(file)
        lines_without_header(file).map do |line|
          MondialRelay::ParcelShops::FetchAll::ParseLine.for(line)
        end
      end

      def lines_without_header(file)
        file.readlines.drop(1)
      end
    end
  end
end
