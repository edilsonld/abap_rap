@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YELD_CDS_BOOKING
  as select from yeld_booking
  composition [0..*] of YELD_CDS_BOOKING_SUP     as _bookingSup
  association        to parent YELD_CDS_TRAVEL   as _travel        on  $projection.TravelId = _travel.TravelId
  association [1..1] to /DMO/I_Customer          as _customer      on  $projection.CustomerId = _customer.CustomerID
  association [1..1] to /DMO/I_Carrier           as _carrier       on  $projection.CarrierId = _carrier.AirlineID
  association [1..1] to /DMO/I_Connection        as _connection    on  $projection.CarrierId    = _connection.AirlineID
                                                                   and $projection.ConnectionId = _connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _bookingStatus on  $projection.BookingStatus = _bookingStatus.BookingStatus
{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,

      // associations
      _bookingSup,
      _travel,
      _customer,
      _carrier,
      _connection,
      _bookingStatus
}
