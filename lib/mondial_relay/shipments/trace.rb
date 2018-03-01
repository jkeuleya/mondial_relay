# frozen_string_literal: true

require 'interactor/initializer'

module MondialRelay
  module Shipments
    # An interface for *shipment* tracing.
    # Requests the {https://api.mondialrelay.com/Web_Services.asmx?op=WSI2_TracingColisDetaille
    # WSI2_TracingColisDetaille} endpoint.
    #
    # Available tracing params (*M* — mandatory, *O* — optional):
    #
    # - **Expedition** — shipment number *M*.
    # - **Langue** — language *M*.
    #
    # **NOTE**: all params must be provided in the order specified above.
    #
    # @example
    #   # Create a shipment and return its number with a label url:
    #   MondialRelay::Shipments::Trace.for(
    #     Expedition: '31236105',
    #     Langue: 'FR',
    #   )
    #
    #   # Results in:
    #   {
    #     stat: '0',
    #     libelle01: 'name',
    #     relais_libelle: 'point name',
    #     relais_num: 'point id',
    #     libelle02: 'extra information',
    #     tracing: 'tracking table',
    #     tracing_libelle: 'tracing name',
    #     tracing_date: 'tracing date',
    #     tracing_heure: 'tracing hour',
    #     tracing_lieu: 'tracing city',
    #     tracing_relais: 'tracking point id',
    #     tracing_pays: 'tracing country',
    #   }
    class Trace
      include Interactor::Initializer

      OPERATION = :wsi2_tracing_colis_detaille

      initialize_with :params

      # @!visibility private
      def run
        MondialRelay::Query.run(OPERATION, params)
      end
    end
  end
end