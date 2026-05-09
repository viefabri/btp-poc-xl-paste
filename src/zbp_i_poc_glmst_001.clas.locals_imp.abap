CLASS lhc_GLAccount DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR GLAccount RESULT result.

    METHODS validateExcelData FOR VALIDATE ON SAVE
      IMPORTING keys FOR GLAccount~validateExcelData.

ENDCLASS.

CLASS lhc_GLAccount IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " PoC環境用：すべての操作（Create/Update/Delete）に対して権限エラーを出さない
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %action-Edit = if_abap_behv=>auth-allowed
                      %delete      = if_abap_behv=>auth-allowed
                      %update      = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateExcelData.
    " 1. ユーザーが入力（ペースト）したデータをドラフトテーブルから読み込む
    READ ENTITIES OF ZR_POC_GLMST_001 IN LOCAL MODE
      ENTITY GLAccount
      FIELDS ( GLAccountType ShortText ) " 検証に必要な項目だけを読み込む
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_glaccounts).

    " 2. 読み込んだデータを1件ずつループしてチェック
    LOOP AT lt_glaccounts INTO DATA(ls_glaccount).

      " 【検証ルール例 1】 勘定タイプの値チェック（例えば 'X', 'N', 'P' 以外はエラーとする）
      IF ls_glaccount-GLAccountType IS NOT INITIAL AND
         ls_glaccount-GLAccountType <> 'X' AND ls_glaccount-GLAccountType <> 'N' AND ls_glaccount-GLAccountType <> 'P'.

        " (A) failed 構造にキーを追加（保存をブロックする）
        APPEND VALUE #( %tky = ls_glaccount-%tky ) TO failed-glaccount.

        " (B) reported 構造にメッセージと、エラー対象の項目（セル）を追加（UIを赤くする）
        APPEND VALUE #( %tky = ls_glaccount-%tky
                        " PoC用：即席のテキストメッセージを生成（本番では Message Class を推奨）
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = '無効な勘定タイプです。X, N, P のいずれかを入力してください。' )
                        " どのセルにエラーマークを付けるかを指定（ここが最重要！）
                        %element-glaccounttype = if_abap_behv=>mk-on ) TO reported-glaccount.
      ENDIF.

      " 【検証ルール例 2】 短縮テキストの文字数チェック（例えば5文字未満はエラー）
      IF ls_glaccount-ShortText IS NOT INITIAL AND strlen( ls_glaccount-ShortText ) < 5.

        APPEND VALUE #( %tky = ls_glaccount-%tky ) TO failed-glaccount.

        APPEND VALUE #( %tky = ls_glaccount-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = '短縮テキストは5文字以上で入力してください。' )
                        %element-shorttext = if_abap_behv=>mk-on ) TO reported-glaccount.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
