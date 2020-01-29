# frozen_string_literal: true

RSpec.describe MondialRelay::ParcelShops::Fetch::Parse, '.for' do
  subject { described_class.for(line) }


  let(:line) do
    'D1RL00105 CHAUSSURES RICHE               521080676252108     D12.10.2017          10.07.202011.07.2020                                                            21.07.2018                                                                                           Ma/Me/J/V/S 9:30-12 13:30-18                                  9904X     XCHAUSSURES RICHE                                              FAUBOURG SAINT GERMAIN 18                                     5660 COUVIN                    521081700N0000000000000000093012001330180009301200133018000930120013301800093012001330180009301200133018000000000000000000NONNNOOBE                         003001      R09245127+0500518840+0044950080                                                                                                                                                                                                                                                                                                                      '
  end

  let(:relais_number) { '00105' }
  let(:name) { "CHAUSSURES RICHE#{' ' * 15}" }
  let(:address) { "CHAUSSURES RICHE#{' ' * 15}" }
  let(:address_additional) { "#{' ' * 32}FAUBOURG SAINT GERMAIN 18#{' ' * 38}"}
  let(:country) { 'BE' }
  let(:city) { "COUVIN#{' ' * 20}" }
  let(:postal_code) { '5660' }
  let(:latitude) { 50.051884 }
  let(:longitude) { 4.495008 }

  let(:business_hours) do
    {
      monday: [],
      tuesday: [
        {
          opens_at: '09:30',
          closes_at: '12:00',
        },
        {
          opens_at: '13:30',
          closes_at: '18:00',
        },
      ],
      wednesday: [
        {
          opens_at: '09:30',
          closes_at: '12:00',
        },
        {
          opens_at: '13:30',
          closes_at: '18:00',
        },
      ],
      thursday: [
        {
          opens_at: '09:30',
          closes_at: '12:00',
        },
        {
          opens_at: '13:30',
          closes_at: '18:00',
        },
      ],
      friday: [
        {
          opens_at: '09:30',
          closes_at: '12:00',
        },
        {
          opens_at: '13:30',
          closes_at: '18:00',
        },
      ],
      saturday: [
        {
          opens_at: '09:30',
          closes_at: '12:00',
        },
        {
          opens_at: '13:30',
          closes_at: '18:00',
        },
      ],
      sunday: [],
    }
  end

  let(:holiday_information) do
    [
      {
        starts_at: '10.07.2020',
        ends_at: '11.07.2020',
      },
    ]
  end

  let(:result) do
    {
      id: relais_number,
      name: name,
      address: address,
      address_additional: address_additional,
      country: country,
      city: city,
      postal_code: postal_code,
      latitude: latitude,
      longitude: longitude,
      business_hours: business_hours,
      holiday_information: holiday_information,
    }
  end

  it { is_expected.to eq(result) }
end
