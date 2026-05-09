@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '勘定科目マスタ Base BO (Composite)'
@VDM.viewType: #COMPOSITE
define root view entity ZR_POC_GLMST_001
  as select from ZI_POC_GLMST_001
{
  key CompanyCode,
  key GLAccount,
      GLAccountGroup,
      GLAccountType,
      ShortText,
      LongText,
      FieldStatusGroup,
      Currency,
      IsBalanceSheetAccount,
      IsOpenItemManaged,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
