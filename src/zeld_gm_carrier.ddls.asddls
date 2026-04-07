@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entidade Carrier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZELD_GM_CARRIER
  as select from /dmo/carrier
{
  key carrier_id as CarrierId,
  
  @Semantics.text: true      
      name       as Name
}
