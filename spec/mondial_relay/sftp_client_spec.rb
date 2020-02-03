# frozen_string_literal: true

RSpec.describe MondialRelay::SftpClient do
  describe '#with_connection' do
    let(:connection) { double(:connection) }
    let(:config) { build(:configuration) }

    let(:connection_options) do
      {
        timeout: config.sftp_connect_timeout,
        password: config.sftp_password,
        non_interactive: true,
        port: described_class::SFTP_PORT,
      }
    end

    before do
      allow(MondialRelay)
        .to receive(:config)
        .and_return(config)
    end

    it 'opens a connection and yields control' do
      expect(Net::SFTP).to receive(:start).with(
        config.sftp_host,
        config.sftp_user,
        connection_options,
      ).and_yield(connection)

      expect { |block| described_class.new.with_connection(&block) }
        .to yield_with_args(connection)
    end

    context 'when an error is raised' do
      before do
        expect(Net::SFTP).to receive(:start).and_raise(Net::SFTP::Exception)
      end

      it 'raises a client error' do
        expect { |block| described_class.new.with_connection(&block) }
          .to raise_error(MondialRelay::ClientError)
      end
    end
  end
end
