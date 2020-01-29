# frozen_string_literal: true

RSpec.describe MondialRelay::ParcelShops::Fetch, '.for' do
  subject { described_class.for }

  let(:connection) { double(:connection) }
  let(:tempfile) { double(:tempfile, path: tempfile_path) }
  let(:tempfile_path) { 'dummy-path' }
  let(:line) { double(:line) }
  let(:lines) { [line] }
  let(:result) { double(:result) }

  before do
    expect(MondialRelay)
      .to receive_message_chain(:sftp_client, :with_connection)
      .and_yield(connection)

    expect(Tempfile)
      .to receive(:create)
      .with(described_class::FILENAME)
      .and_yield(tempfile)

    expect(connection)
      .to receive(:download!)
      .with(described_class::RELAIS_PATH, tempfile_path)

    expect(tempfile)
      .to receive_message_chain(:readlines, :drop)
      .and_return(lines)

    expect(MondialRelay::ParcelShops::Fetch::Parse)
      .to receive(:for)
      .with(line)
      .and_return(result)
  end

  it { is_expected.to eq([result]) }
end
