@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_stock_case
  as select from ztpp_stock_case
  association [1..*] to zc_po_case  as _ProductionOrd  on  _ProductionOrd.Material = $projection.Material
                                                       and _ProductionOrd.Plant    = $projection.Plant
  association [1..*] to zc_sto_case as _StockTransport on  _StockTransport.Material = $projection.Material
                                                       and _StockTransport.RecPlant = $projection.Plant
{
  key material    as Material,
  key plant       as Plant,
      name        as Name,
      plantname   as PlantName,
      quantity    as Quantity,
      issued_date as IssuedDate,
      ' '         as Icon,
      @ObjectModel: {
      virtualElementCalculatedBy: 'ABAP:ZCL_CALCULATED_STOCK'
      }
      ' '         as Icono,
      _ProductionOrd,
      _StockTransport
}
