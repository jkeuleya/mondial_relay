# frozen_string_literal: true

RSpec.describe MondialRelay::ParcelShops::Search::FormatResponse, '.for' do
  subject { described_class.for(response) }

  context 'with multiple results' do
    let(:response) do
      {
        points_relais: {
          point_relais_details: [
            {
              name: 'Dummy shop',
              holiday_information: {
                period: {
                  starts_at: Time.new(2019, 8, 5).utc,
                  ends_at: Time.new(2019, 8, 15).utc,
                },
              },
              monday_business_hours: {
                string: %w(0800 1130 1300 2130),
              },
              tuesday_business_hours: {
                string: %w(0800 2130),
              },
              sunday_business_hours: {
                string: %w(0000 0000 0000 0000),
              },
            },
          ],
        },
      }
    end

    it 'formats business hours and holiday information' do
      expect(subject).to contain_exactly(
        name: 'Dummy shop',
        holiday_information: [
          {
            starts_at: Time.new(2019, 8, 5).utc,
            ends_at: Time.new(2019, 8, 15).utc,
          },
        ],
        business_hours: {
          monday: [
            {
              opens_at: '08:00',
              closes_at: '11:30',
            },
            {
              opens_at: '13:00',
              closes_at: '21:30',
            },
          ],
          tuesday: [
            {
              opens_at: '08:00',
              closes_at: '21:30',
            },
          ],
          sunday: [],
        },
      )
    end
  end

  context 'with a single result and multiple holidays' do
    let(:response) do
      {
        points_relais: {
          point_relais_details: {
            name: 'Dummy shop',
            holiday_information: {
              period: [
                {
                  starts_at: Time.new(2019, 8, 5).utc,
                  ends_at: Time.new(2019, 8, 15).utc,
                },
                {
                  starts_at: Time.new(2019, 9, 1).utc,
                  ends_at: Time.new(2019, 9, 5).utc,
                },
              ],
            },
            tuesday_business_hours: {
              string: %w(0800 2130),
            },
          },
        },
      }
    end

    it 'formats business hours and holiday information' do
      expect(subject).to contain_exactly(
        name: 'Dummy shop',
        holiday_information: [
          {
            starts_at: Time.new(2019, 8, 5).utc,
            ends_at: Time.new(2019, 8, 15).utc,
          },
          {
            starts_at: Time.new(2019, 9, 1).utc,
            ends_at: Time.new(2019, 9, 5).utc,
          },
        ],
        business_hours: {
          tuesday: [
            {
              opens_at: '08:00',
              closes_at: '21:30',
            },
          ],
        },
      )
    end
  end
end
