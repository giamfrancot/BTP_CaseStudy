@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZTPP_PO_CASE'

define root view entity ZR_TPP_PO_CASE
  as select from ztpp_po_case as POrder
{
  key prod_order as ProdOrder,
  material as Material,
  quantity as Quantity,
  start_d as StartD,
  finish_d as FinishD,
  plant as Plant,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_change_at as LastChangeAt
  
}
