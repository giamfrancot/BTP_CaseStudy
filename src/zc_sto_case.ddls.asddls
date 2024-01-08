@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity Stock Transport Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_sto_case
  as select from ztpp_sto_case
{
  key sto       as Sto,
      material  as Material,
      quantity  as Quantity,
      requir_d  as RequirD,
      sup_plant as SupPlant,
      rec_plant as RecPlant,
      case
      when sto_close = 'X' then 1
      else 3
      end       as Icono,
      ''        as Icon
}
