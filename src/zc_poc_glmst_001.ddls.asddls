@EndUserText.label: '勘定科目マスタ (UI用プロジェクション)' // オブジェクトの用途ラベル
@AccessControl.authorizationCheck: #NOT_REQUIRED      // 権限チェック: PoCのため不要
@Metadata.allowExtensions: true                       // メタデータ拡張の許可: UIレイアウト定義を別ファイル(MDE)に分離する必須設定
@Search.searchable: true                              // 検索機能の有効化: Fioriのグローバル検索バーを使用可能にする
@ObjectModel.semanticKey: ['CompanyCode', 'GLAccount'] // セマンティックキー: ユーザーにとって意味のあるキー項目を指定 (Fioriのルーティング等で使用)

define root view entity ZC_POC_GLMST_001
  provider contract transactional_query               // トランザクションクエリの宣言: RAPでCRUD(Draft含む)を行うUI用ビューとしての標準規格
  as projection on ZI_POC_GLMST_001                   // ソースとなるInterface Viewを指定
{
      // ======================================================================
      // 1. ビジネスキー項目
      // ======================================================================
      @EndUserText.label: '会社コード'
      @Search.defaultSearchElement: true              // 検索対象に含める
  key CompanyCode,

      @EndUserText.label: '勘定科目'
      @Search.defaultSearchElement: true              // 検索対象に含める
  key GLAccount,

      // ======================================================================
      // 2. 属性（データ）項目
      // ======================================================================
      @EndUserText.label: '勘定グループ'
      GLAccountGroup,

      @EndUserText.label: '勘定タイプ'
      GLAccountType,

      @EndUserText.label: '短縮テキスト'
      ShortText,

      @EndUserText.label: '勘定科目名'
      @Search.defaultSearchElement: true              // 検索対象に含める（名称での曖昧検索を可能にする）
      @Search.fuzzinessThreshold: 0.8                 // 曖昧検索の許容度（0.8はタイプミスなどをある程度許容する標準値）
      LongText,

      @EndUserText.label: '項目ステータス群'
      FieldStatusGroup,

      @EndUserText.label: '勘定通貨'
      Currency,

      @EndUserText.label: '貸借対照表勘定'
      IsBalanceSheetAccount,

      @EndUserText.label: '損益勘定区分'
      IsOpenItemManaged,

      // ======================================================================
      // 3. RAP Managed / Draft 管理項目
      // ※ UI上には基本的に表示しませんが、バックエンドでの制御や排他制御（ETag）に
      //    必要となるため、Projection層にも必ず含めておく必要があります。
      // ======================================================================
      @EndUserText.label: '作成者'
      CreatedBy,
      
      @EndUserText.label: '作成日時'
      CreatedAt,
      
      @EndUserText.label: '最終更新者'
      LastChangedBy,
      
      @EndUserText.label: 'ローカル最終更新日時'
      LocalLastChangedAt,
      
      @EndUserText.label: '全体最終更新日時'
      LastChangedAt
}
