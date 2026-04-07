@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entidade Carrier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZELD_GM_AIRPORT
  as select from /dmo/airport
{
  key airport_id as AirportId,

      @Semantics.text: true
      name       as Name,
      city       as City,
      country    as Country
}
