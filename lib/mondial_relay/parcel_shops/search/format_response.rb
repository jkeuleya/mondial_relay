# frozen_string_literal: true

require 'interactor/initializer'
require 'active_support/core_ext/array/wrap'

module MondialRelay
  module ParcelShops
    class Search
      class FormatResponse
        include Interactor::Initializer

        WEEKDAYS = %i(
          monday
          tuesday
          wednesday
          thursday
          friday
          saturday
          sunday
        ).freeze

        initialize_with :response

        def run
          Array.wrap(resources).map do |resource|
            resource
              .except(*keys_to_skip)
              .merge(
                holiday_information: holiday_information(resource),
                business_hours: business_hours(resource),
              )
          end
        end

        def resources
          response.dig(:points_relais, :point_relais_details)
        end

        def keys_to_skip
          WEEKDAYS.map { |weekday| weekday_key(weekday) }
        end

        def weekday_key(weekday)
          "#{weekday}_business_hours".to_sym
        end

        def business_hours(resource)
          WEEKDAYS.each_with_object({}) do |weekday, result|
            business_hours = resource.dig(weekday_key(weekday), :string)
            next unless business_hours

            result[weekday] = business_hour_periods(business_hours)
          end
        end

        def business_hour_periods(business_hours)
          business_hours.each_slice(2).map do |opens_at, closes_at|
            next if opens_at == '0000' && closes_at == '0000'

            {
              opens_at: "#{opens_at[0..1]}:#{opens_at[2..3]}",
              closes_at: "#{closes_at[0..1]}:#{closes_at[2..3]}",
            }
          end.compact
        end

        def holiday_information(resource)
          Array.wrap(resource.dig(:holiday_information, :period))
        end
      end
    end
  end
end
