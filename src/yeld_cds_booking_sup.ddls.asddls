@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YELD_CDS_BOOKING_SUP
  as select from yeld_booking_sup

  association        to parent YELD_CDS_BOOKING as _booking        on  $projection.TravelId  = _booking.TravelId
                                                                   and $projection.BookingId = _booking.BookingId
                                                                   
  association [1..1] to YELD_CDS_TRAVEL as _travel on $projection.TravelId = _travel.TravelId                                                                    
  association [1..1] to /DMO/I_Supplement       as _product        on  $projection.SupplementId = _product.SupplementID
  association [1..*] to /DMO/I_SupplementText   as _supplementText on  $projection.SupplementId = _supplementText.SupplementID
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      
      _travel,  
      _booking,
      _product,
      _supplementText
}
