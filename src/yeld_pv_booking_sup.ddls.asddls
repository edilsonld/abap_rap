@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View - Booking Suppl. entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity YELD_PV_BOOKING_SUP
  as projection on YELD_CDS_BOOKING_SUP
{      
  key TravelId,
  key BookingId,
  key BookingSupplementId,

      @ObjectModel.text.element: [ 'SupplementDescription' ]
      SupplementId,
      _supplementText.Description as SupplementDescription : localized,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,     
      CurrencyCode,     
      LastChangedAt,
      
      /* Associations */
      _travel :redirected to YELD_PV_TRAVEL,
      _booking : redirected to parent YELD_PV_BOOKING,
      _supplementText
}
