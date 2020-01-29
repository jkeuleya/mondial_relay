# frozen_string_literal: true

module MondialRelay
  module ParcelShops
    class Fetch
      class Parse
        include Interactor::Initializer

        initialize_with :line

        WEEKDAYS = %i(
          monday
          tuesday
          wednesday
          thursday
          friday
          saturday
          sunday
        ).freeze

        def run
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

        private

        def format(value)
          value.strip.downcase.titleize
        end

        def name
          format(line.slice(10, 31))
        end

        def relais_number
          line.slice(4, 5)
        end

        def address
          format(line.slice(336, 31))
        end

        def address_additional
          format(
            "#{line.slice(3671, 31)} " \
            "#{line.slice(398, 31)} " \
            "#{line.slice(429, 31)}"
          )
        end

        def country
          line.slice(620, 2)
        end

        def postal_code
          line.slice(460, 5).strip
        end

        def city
          format(line.slice(465, 26))
        end

        def latitude
          "#{line[668]}#{line.slice(669, 3)}.#{line.slice(672, 7)}".to_f
        end

        def longitude
          "#{line[679]}#{line.slice(680, 3)}.#{line.slice(683, 7)}".to_f
        end

        def business_hours
          position = 501

          WEEKDAYS.each_with_object({}) do |weekday, result|
            result[weekday] = parse_business_hours(position)

            position += 16
          end
        end

        def parse_business_hours(position)
          [
            opening_hours(position, position + 4),
            opening_hours(position + 8, position + 12),
          ].compact
        end

        def opening_hours(opens_at_position, closes_at_position)
          opens_at = line.slice(opens_at_position, 4)
          closes_at = line.slice(closes_at_position, 4)

          return if opens_at == '0000' && closes_at == '0000'

          {
            opens_at: "#{opens_at[0..1]}:#{opens_at[2..3]}",
            closes_at: "#{closes_at[0..1]}:#{closes_at[2..3]}",
          }
        end

        def holiday_information
          start_position = 82

          (0..3).each_with_object([]) do |index, result|
            position = start_position + index * 20

            result.push(parse_holiday_information(position))
          end.compact
        end

        def parse_holiday_information(position)
          starts_at = line.slice(position, 10).strip
          ends_at = line.slice(position + 10, 10).strip

          return if starts_at.blank?  && ends_at.blank?

          {
            starts_at: starts_at,
            ends_at: ends_at,
          }
        end
      end
    end
  end
end
