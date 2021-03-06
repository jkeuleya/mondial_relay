# frozen_string_literal: true

RSpec.describe MondialRelay::ParcelShops::FetchAll, '.for' do
  subject { described_class.for }

  let(:connection) { double(:connection) }
  let(:tempfile) { double(:tempfile, path: tempfile_path) }
  let(:tempfile_path) { 'dummy-path' }
  let(:line) { double(:line) }
  let(:lines) { [line] }
  let(:result) { double(:result) }
  let(:config) { build(:configuration) }

  before do
    allow(MondialRelay)
      .to receive(:config)
      .and_return(config)

    expect(MondialRelay)
      .to receive_message_chain(:sftp_client, :with_connection)
      .and_yield(connection)

    expect(Tempfile)
      .to receive(:create)
      .with(described_class::FILENAME)
      .and_yield(tempfile)

    expect(connection)
      .to receive(:download!)
      .with(config.sftp_relais_path, tempfile_path)

    expect(tempfile)
      .to receive_message_chain(:readlines, :drop)
      .and_return(lines)

    expect(MondialRelay::ParcelShops::FetchAll::ParseLine)
      .to receive(:for)
      .with(line)
      .and_return(result)
  end

  it { is_expected.to eq([result]) }
end
