CLASS zcl_consume_api_case_study DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CONSTANTS:
        c_x TYPE c VALUE 'X'.
    TYPES:
      tt_porders TYPE ztpp_po_case,
      tt_sto     TYPE ztpp_sto_case,

      gt_porders TYPE TABLE OF tt_porders,
      gt_sto     TYPE TABLE OF tt_sto,

      BEGIN OF post_s,
        user_id TYPE i,
        id      TYPE i,
        title   TYPE string,
        body    TYPE string,
      END OF post_s,

      post_tt TYPE TABLE OF post_s WITH EMPTY KEY,

      BEGIN OF post_without_id_s,
        user_id TYPE i,
        title   TYPE string,
        body    TYPE string,
      END OF post_without_id_s.

    METHODS:
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

      "We have to create a similar method for Production Orders and STO
      read_posts
        RETURNING VALUE(result) TYPE post_tt
        RAISING   cx_static_check,

      fill_tables
        IMPORTING result_po  TYPE gt_porders
                  result_sto TYPE gt_sto

        RAISING   cx_static_check.

  PROTECTED  SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      base_url     TYPE string VALUE 'https://jsonplaceholder.typicode.com/posts', "It has to be changed to an external API
      content_type TYPE string VALUE 'Content-type',
      json_content TYPE string VALUE 'application/json; charset=UTF-8'.
ENDCLASS.



CLASS zcl_consume_api_case_study IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    TRY.
        "this method consumes an API and retrieve the data
        DATA(all_posts) = read_posts(  ).
        "Execute logic to fill BTP persistence tables / Production Order and STO

        "This sentence print the returned values on screen.
        out->write( all_posts ).

      CATCH cx_root INTO DATA(exc).

        out->write( exc->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD create_client.
    "Connect with an API
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD.

  METHOD read_posts.
    " Get JSON
    DATA(url) = |{ base_url }|.
    DATA(client) = create_client( url ).
    DATA(response) = client->execute( if_web_http_client=>get )->get_text(  ).
    client->close(  ).

    " Convert JSON to a table
    xco_cp_json=>data->from_string( response )->apply(
      VALUE #( ( xco_cp_json=>transformation->camel_case_to_underscore ) )
      )->write_to( REF #( result ) ).
  ENDMETHOD.

  METHOD fill_tables.
    DATA: lt_result_sto TYPE gt_sto.




    "Retrieve STO data to check uncompleted STO
    SELECT FROM ztpp_sto_case
           FIELDS *
           WHERE sto_close EQ @space
           INTO TABLE @DATA(lt_sto).

    lt_result_sto = result_sto.
    APPEND LINES OF lt_sto TO lt_result_sto.
    SORT lt_result_sto BY material ASCENDING
                          requir_d ASCENDING.

    "Retrieve Material Stock stored.
    SELECT FROM ztpp_stock_case
           FIELDS *
           INTO TABLE @DATA(lt_stock).


    "Add all new supply that is coming through External API
    DATA ls_stock TYPE ztpp_stock_case.
    LOOP AT result_po INTO DATA(ls_po).
      TRY.
          ASSIGN lt_stock[ material = ls_po-material plant = ls_po-plant ] TO FIELD-SYMBOL(<fs_stock>).
          IF sy-subrc IS INITIAL.
            <fs_stock>-quantity = <fs_stock>-quantity + ls_po-quantity.
            <fs_stock>-issued_date = ls_po-finish_d.
          ELSE.
            CLEAR: ls_stock.
            ls_stock-material    = ls_po-material.
            ls_stock-quantity    = ls_po-quantity.
            ls_stock-plant       = ls_po-plant.
            ls_stock-issued_date = ls_po-finish_d.
            APPEND ls_stock TO lt_stock.
          ENDIF.
        CATCH cx_root INTO DATA(cx).
      ENDTRY.
    ENDLOOP.

    "Complete the new STO (Demand) and complete the unfulfilled STOs.
    LOOP AT lt_result_sto ASSIGNING FIELD-SYMBOL(<fs_sto>).
      TRY.
          <fs_stock> = lt_stock[ material = ls_po-material plant = <fs_sto>-sup_plant ].
          IF sy-subrc IS INITIAL.
            IF ls_stock-quantity >= <fs_sto>-quantity AND ls_stock-issued_date GE <fs_sto>-requir_d.
              <fs_sto>-sto_close = c_x.
              IF <fs_sto>-rec_plant EQ <fs_sto>-sup_plant.
                <fs_stock>-quantity = <fs_stock>-quantity - <fs_sto>-quantity.
              ELSE.
                <fs_stock>-quantity = <fs_stock>-quantity - <fs_sto>-quantity.
                <fs_stock> = lt_stock[ material = ls_po-material plant = <fs_sto>-rec_plant ].
                IF sy-subrc IS INITIAL.
                  <fs_stock>-quantity = <fs_stock>-quantity + <fs_sto>-quantity.
                ELSE.
                  CLEAR: ls_stock.
                  ls_stock-material    = <fs_sto>-material.
                  ls_stock-quantity    = <fs_sto>-quantity.
                  ls_stock-plant       = <fs_sto>-rec_plant.
                  ls_stock-issued_date = <fs_sto>-requir_d.
                  APPEND ls_stock TO lt_stock.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        CATCH cx_root INTO cx.
      ENDTRY.
    ENDLOOP.

    "Insert/modify persistence tables
    INSERT ztpp_po_case  FROM TABLE @result_po.
    MODIFY ztpp_sto_case FROM TABLE @lt_result_sto.
    MODIFY ztpp_stock_case FROM TABLE @lt_stock.
  ENDMETHOD.

ENDCLASS.
