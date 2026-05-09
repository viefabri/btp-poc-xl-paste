@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST] // 拡張許可: 顧客要件による将来的な項目の追加を許可
@AccessControl.authorizationCheck: #NOT_REQUIRED         // 権限チェック: 今回のPoCでは不要とする
@EndUserText.label: '勘定科目マスタ'                     // テキスト: オブジェクトの用途を示すラベル
@Metadata.ignorePropagatedAnnotations: false             // メタデータを引き継ぐ: 下位レイヤーのアノテーションを有効化
@ObjectModel.semanticKey: ['CompanyCode', 'GLAccount'] // V4ドラフト用のキー宣言
@VDM.viewType: #BASIC                                    // VDMレイヤー: 最下層のインターフェースビュー（物理テーブルとの1対1マッピング）

@ObjectModel.usageType: {
    serviceQuality: #A,
    sizeCategory:   #L,
    dataClass:      #MASTER
}

define view entity ZI_POC_GLMST_001
  as select from zpoc_glmst_001 as GLAccount
{
      // ======================================================================
      // 1. ビジネスキー項目
      // ======================================================================
      @EndUserText.label: '会社コード'
  key bukrs                 as CompanyCode,           // [キー] 会社コード

      @EndUserText.label: '勘定科目'
  key saknr                 as GLAccount,             // [キー] 勘定科目

      // ======================================================================
      // 2. 属性（データ）項目
      // ======================================================================
      @EndUserText.label: '勘定グループ'
      ktoks                 as GLAccountGroup,        // 勘定グループ (必須入力想定)

      @EndUserText.label: '勘定タイプ'
      glaccount_type        as GLAccountType,         // 勘定タイプ (S/4HANA標準準拠区分)

      @EndUserText.label: '短縮テキスト'
      txt20                 as ShortText,             // 短縮テキスト (20文字)

      @EndUserText.label: '勘定科目名'
      txt50                 as LongText,              // 勘定科目名 (50文字)

      @EndUserText.label: '項目ステータス群'
      fstat                 as FieldStatusGroup,      // 項目ステータス群

      @EndUserText.label: '勘定通貨'
      waers                 as Currency,              // 勘定通貨コード

      @EndUserText.label: '貸借対照表勘定'
      xbala                 as IsBalanceSheetAccount, // 貸借対照表勘定区分 (フラグ/チェックボックス)

      @EndUserText.label: '損益勘定区分'
      xgvlt                 as IsOpenItemManaged,     // 損益勘定区分 (フラグ/チェックボックス)

      // ======================================================================
      // 3. RAP Managed / Draft 管理項目（フレームワーク自動更新）
      // ======================================================================
      @Semantics.user.createdBy: true
      @EndUserText.label: '作成者'
      created_by            as CreatedBy,             // レコード初回作成ユーザ

      @Semantics.systemDateTime.createdAt: true
      @EndUserText.label: '作成日時'
      created_at            as CreatedAt,             // レコード初回作成日時

      @Semantics.user.localInstanceLastChangedBy: true
      @EndUserText.label: '最終更新者'
      last_changed_by       as LastChangedBy,         // レコード最終更新ユーザ

      // --- ETag項目 (同時実行制御・オプティミスティックロック用) ---
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @EndUserText.label: 'ローカル最終更新日時'
      local_last_changed_at as LocalLastChangedAt,    // 該当レコードの最終更新日時 (ETag制御の要)

      // --- 全体更新日時 ---
      @Semantics.systemDateTime.lastChangedAt: true
      @EndUserText.label: '全体最終更新日時'
      last_changed_at       as LastChangedAt          // テーブル全体の最終更新状態管理
}
