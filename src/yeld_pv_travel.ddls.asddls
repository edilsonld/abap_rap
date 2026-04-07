@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View - Travel entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity YELD_PV_TRAVEL
  provider contract transactional_query
  as projection on YELD_CDS_TRAVEL
{
      
  key TravelId,
      
      @ObjectModel.text.element: [ 'AgencyName' ]      
      AgencyId,
      _agency.name       as AgencyName,

      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.LastName as CustomerName,    
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,      
      CurrencyCode, 
      
      @ObjectModel.text.element: [ 'OverallStatusText' ]    
      OverallStatus,      
      _overallStatus._Text.Text as OverallStatusText: localized,      
      Description,   
      LastChangedAt,
      /* Associations */
      _booking : redirected to composition child YELD_PV_BOOKING,
      
      _agency,
      _customer,
      _overallStatus
}
