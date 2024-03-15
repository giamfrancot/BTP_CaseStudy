@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TPP_PO_CASE'
@ObjectModel.semanticKey: [ 'ProdOrder' ]
define root view entity ZC_TPP_PO_CASE
  provider contract transactional_query
  as projection on ZR_TPP_PO_CASE
{
  key ProdOrder,
  Material,
  Quantity,
  StartD,
  FinishD,
  Plant,
  LocalLastChangedAt
  
}
