# frozen_string_literal: true

RSpec.describe MondialRelay::Query, '.run' do
  subject { described_class.run(service, operation, account, params) }

  let(:service) { build(:generic_service) }
  let(:client) { service.client }

  let(:operation) { :test }
  let(:account) { build(:account) }
  let(:params) { {} }

  let(:response) { double(:response) }
  let(:body) do
    {
      test_response: {
        test_result: {
          stat: '0',
        },
      },
    }
  end

  before do
    stub_request(:get, client.wsdl_url)

    allow(client).to receive(:call).and_return(response)
    allow(response).to receive(:body).and_return(body)
  end

  it 'returns an api response' do
    expect(subject).to eq(stat: '0')
  end

  context 'when Mondial responds with an empty data tree' do
    let(:body) do
      {
        test_response: {
          test_result: {
            stat: nil,
            tracing: {
              ret_wsi2_sub_tracing_colis_detaille: [nil, nil, nil],
            },
          },
        },
      }
    end

    it 'raises a ResponseError with status code 99' do
      expect { subject }.to raise_error MondialRelay::ResponseError do |error|
        expect(error.status).to eq(MondialRelay::StatusCodes.generic_service_error_code)
      end
    end
  end

  context 'when Mondial responds with a partially empty data tree' do
    let(:body) do
      {
        test_response: {
          test_result: {
            stat: nil,
            tracing: {
              ret_wsi2_sub_tracing_colis_detaille: ['anything', nil, nil],
            },
          },
        },
      }
    end

    it 'raises a ResponseError with an empty code' do
      expect { subject }.to raise_error MondialRelay::ResponseError do |error|
        expect(error.status).to eq(nil)
      end
    end
  end
end
