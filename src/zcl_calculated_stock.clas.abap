CLASS zcl_calculated_stock DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_calculated_stock IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    CHECK line_exists( it_requested_calc_elements[ table_line = 'ICONO' ] ).

    DATA ls_filed_data TYPE string.
    ls_filed_data = 'MATERIAL'. INSERT ls_filed_data INTO TABLE et_requested_orig_elements.
    ls_filed_data = 'PLANT'. INSERT ls_filed_data INTO TABLE et_requested_orig_elements.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    CHECK NOT it_original_data IS INITIAL.

    DATA: lt_stock_data TYPE TABLE OF zc_stock_case WITH DEFAULT KEY.

    lt_stock_data = CORRESPONDING #( it_original_data ).

    IF lt_stock_data[] IS NOT INITIAL.
      SELECT FROM ztpp_sto_case
             FIELDS material, rec_plant, sto_close
             FOR ALL ENTRIES IN @lt_stock_data
             WHERE material  = @lt_stock_data-material AND
                   rec_plant = @lt_stock_data-Plant AND
                   sto_close NE @space
             INTO TABLE @DATA(lt_sto).
    ENDIF.

    LOOP AT lt_stock_data ASSIGNING FIELD-SYMBOL(<fs_stock>).
      TRY.
          DATA(ls_sto) = lt_sto[ material = <fs_stock>-Material rec_plant = <fs_stock>-Plant ].
          IF sy-subrc IS INITIAL.
            <fs_stock>-Icono = '1'.
          ENDIF.
        CATCH cx_root INTO DATA(cx).
          <fs_stock>-Icono = '3'.
      ENDTRY.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_stock_data ).
  ENDMETHOD.

ENDCLASS.
