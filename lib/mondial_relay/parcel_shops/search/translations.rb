# frozen_string_literal: true

module MondialRelay
  module ParcelShops
    class Search
      module Translations
        PARAMS = {
          country: :Pays,
          parcel_shop_id: :NumPointRelais,
          city: :Ville,
          postal_code: :CP,
          latitude: :Latitude,
          longitude: :Longitude,
          parcel_size: :Taille,
          parcel_weight: :Poids,
          delivery_mode: :Action,
          lead_time: :DelaiEnvoi,
          search_radius: :RayonRecherche,
          trade_type: :TypeActivite,
          nance: :NACE,
          number_of_results: :NombreResultats,
        }.freeze

        RESPONSE = {
          num: :id,
          lg_adr1: :name,
          lg_adr2: :name_additional,
          lg_adr3: :address,
          lg_adr4: :address_additional,
          cp: :postal_code,
          ville: :city,
          pays: :country,
          localisation1: :extra_information,
          localisation2: :extra_information_additional,
          type_activite: :trade_type,
          horaires_lundi: :monday_business_hours,
          horaires_mardi: :tuesday_business_hours,
          horaires_mercredi: :wednesday_business_hours,
          horaires_jeudi: :thursday_business_hours,
          horaires_vendredi: :friday_business_hours,
          horaires_samedi: :saturday_business_hours,
          horaires_dimanche: :sunday_business_hours,
          informations_dispo: :holiday_information,
          periode: :period,
          debut: :starts_at,
          fin: :ends_at,
        }.freeze
      end
    end
  end
end
