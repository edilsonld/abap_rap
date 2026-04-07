@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View - Booking entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity YELD_PV_BOOKING
  as projection on YELD_CDS_BOOKING
{

      
  key TravelId,

      
  key BookingId,

      
      BookingDate,

      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.LastName        as CustomerName,

      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,      
      _carrier.Name             as CarrierName,

      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight', element: 'AirlineID' } ,
                                           additionalBinding: [ { localElement: 'FlightDate', element: 'FlightDate' },
                                                                { localElement: 'CarrierId', element: 'AirlineID' },
                                                                { localElement: 'FlightPrice', element: 'Price' },
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' } ] }]      
      ConnectionId,

      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight', element: 'FlightDate' } ,
                                           additionalBinding: [ { localElement: 'ConnectionId', element: 'ConnectionID' },
                                                                { localElement: 'CarrierId', element: 'AirlineID' },
                                                                { localElement: 'FlightPrice', element: 'Price' },
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' } ] }]     
      FlightDate,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,     
      CurrencyCode,
      
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,     
      _bookingStatus._Text.Text as BookingStatusText : localized,     
      LastChangedAt,

      /* Associations */
      _travel : redirected to parent YELD_PV_TRAVEL,
      _bookingSup : redirected to composition child YELD_PV_BOOKING_SUP,
      _customer,
      _carrier,
      _bookingStatus
}
