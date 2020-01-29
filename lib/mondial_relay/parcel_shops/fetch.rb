# frozen_string_literal: true

module MondialRelay
  module ParcelShops
    class Fetch
      include Interactor::Initializer

      RELAIS_PATH = '/depuismrelay/relais.txt'
      FILENAME = 'relais.txt'

      def run
        MondialRelay.sftp_client.with_connection do |conn|
          Tempfile.create(FILENAME) do |file|
            conn.download!(RELAIS_PATH, file.path)

            parse_file(file)
          end
        end
      end

      private

      def parse_file(file)
        lines(file).each_with_object([]) do |line, points|
          points.push(
            MondialRelay::ParcelShops::Fetch::Parse.for(line)
          )
        end
      end

      def lines(file)
        file.readlines.drop(1)
      end
    end
  end
end
