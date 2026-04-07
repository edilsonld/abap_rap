@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entidade Carrier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZELD_GM_FLIGHT
  as select from /dmo/flight
  association [1..1] to ZELD_GM_CARRIER as _airline on $projection.CarrierId = _airline.CarrierId
{
      @UI.facet: [{
                id: 'Filght',
                purpose: #STANDARD,
                position: 10,
                label: 'Vôos',
                type: #IDENTIFICATION_REFERENCE
            }]
      @UI: {
        lineItem: [{ position: 10 }],
        identification: [{ position: 10 }]
      }
  key carrier_id     as CarrierId,

      @UI: {
        lineItem: [{ position: 20 }],
        identification: [{ position: 20 }]
      }
  key connection_id  as ConnectionId,

      @UI: {
      lineItem: [{ position: 30 }],
      identification: [{ position: 30 }]
      }
  key flight_date    as FlightDate,

      @UI: {
        lineItem: [{ position: 40 }],
        identification: [{ position: 40 }]
      }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price          as Price,

      @UI: {
        lineItem: [{ position: 50 }],
        identification: [{ position: 50 }]
      }
      currency_code  as CurrencyCode,

      @UI: {
        lineItem: [{ position: 60 }],
        identification: [{ position: 60 }]
      }
      plane_type_id  as PlaneTypeId,

      @UI: {
        lineItem: [{ position: 70 }],
        identification: [{ position: 70 }]
      }
      seats_max      as SeatsMax,

      @UI: {
        lineItem: [{ position: 80 }],
        identification: [{ position: 80 }]
      }
      seats_occupied as SeatsOccupied,

      // association
      _airline
}
