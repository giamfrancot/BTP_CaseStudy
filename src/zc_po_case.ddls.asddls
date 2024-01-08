@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity Production Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_po_case
  as select from ztpp_po_case
{
  key prod_order as ProdOrder,
      material   as Material,
      quantity   as Quantity,
      start_d    as StartD,
      finish_d   as FinishD,
      plant      as Plant
}
