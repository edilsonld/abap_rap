@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entidade Carrier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZELD_GM_CONNECTION
  as select from /dmo/connection
  association [1..*] to ZELD_GM_FLIGHT  as _flight  on  $projection.CarrierId    = _flight.CarrierId
                                                    and $projection.ConnectionId = _flight.ConnectionId
  association [1..1] to ZELD_GM_CARRIER as _carrier on  $projection.CarrierId = _carrier.CarrierId
  association [1..1] to ZELD_GM_AIRPORT as _airportFrom on $projection.AirportFromId = _airportFrom.AirportId
  association [1..1] to ZELD_GM_AIRPORT as _airportTo on  $projection.AirportToId = _airportTo.AirportId
  
{

      @UI.facet: [{
          id: 'Connection',
          purpose: #STANDARD,
          position: 10,
          label: 'Conexão',
          type: #IDENTIFICATION_REFERENCE
      },
      {
          id: 'Filght',
          purpose: #STANDARD,
          position: 20,
          label: 'Vôos',
          type: #LINEITEM_REFERENCE,
          targetElement: '_flight'
      }]     
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10, label: 'Companhia' }]
      @UI.identification: [{ position: 10, label: 'Companhia' }]
      @ObjectModel.text.association: '_carrier'
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZELD_GM_CARRIER',
              element: 'CarrierId'
          }
      }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key carrier_id      as CarrierId,
      
      @UI.lineItem: [{ position: 20, label: 'Conexão' }]
      @UI.identification: [{ position: 20, label: 'Conexão' }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key connection_id   as ConnectionId,
      
      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 30, label: 'Aeroporto Origem' }]
      @UI.identification: [{ position: 30, label: 'Aeroporto Origem' }]
      @ObjectModel.text.association: '_airportFrom'
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZELD_GM_AIRPORT',
              element: 'AirportId'
          }
      }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      airport_from_id as AirportFromId,
      
      @UI.selectionField: [{ position: 30 }]
      @UI.lineItem: [{ position: 40, label: 'Aeroporto Destino' }]
      @UI.identification: [{ position: 40, label: 'Aeroporto Destino' }]
      @ObjectModel.text.association: '_airportTo'
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZELD_GM_AIRPORT',
              element: 'AirportId'
          }
      }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7     
      airport_to_id   as AirportToId,
      
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      departure_time  as DepartureTime,
      
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      arrival_time    as ArrivalTime,
      
      @UI.lineItem: [{ position: 70 }]  
      @UI.identification: [{ position: 70 }]      
      distance        as Distance,

      @UI.lineItem: [{ position: 80 }]  
      @UI.identification: [{ position: 80 }]      
      distance_unit   as DistanceUnit,

      // association
      _flight,
      _carrier,
      _airportFrom,
      _airportTo
}
