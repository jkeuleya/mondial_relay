# frozen_string_literal: true

RSpec.describe MondialRelay do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  let(:api_url) { 'test' }

  before { MondialRelay.config.api_url = api_url }

  describe '.config' do
    subject { described_class.config }

    it 'returns a configuration' do
      expect(subject).to be_a(MondialRelay::Configuration)
      expect(subject.api_url).to eq(api_url)
    end
  end

  describe '.reset' do
    subject { described_class.reset }

    let(:config) { build(:configuration) }

    it 'resets a configuration' do
      expect(subject.api_url).to eq(config.api_url)
    end
  end

  describe '.configure' do
    let(:api_url) { 'new' }

    before do
      described_class.configure do |config|
        config.api_url = api_url
        config.enabled_services = %i(generic)
      end
    end

    it 'allows to set configuration' do
      expect(described_class.config.api_url).to eq(api_url)
    end

    it 'registers services' do
      expect(described_class.services.resolve(:generic)).not_to be_nil
    end
  end

  describe '.monitor' do
    subject { described_class.monitor(data) }

    let(:monitor) { ->(data) { print data[:attr] } }
    let(:data) { { attr: result } }
    let(:result) { 'attr' }

    before do
      allow(described_class.config).to receive(:monitor).and_return(monitor)
    end

    it 'runs a monitor callback' do
      expect { subject }.to output(result).to_stdout
    end
  end
end
