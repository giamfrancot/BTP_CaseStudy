CLASS zcl_fill_tables_dummy_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FILL_TABLES_DUMMY_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "Logic to insert Dummy DATA

    DATA: lt_po_case TYPE TABLE OF ztpp_po_case,
          lt_stock   TYPE TABLE OF ztpp_stock_case,
          lt_sto     TYPE TABLE OF ztpp_sto_case.

    "fill internal table
    lt_po_case = VALUE #(
    ( prod_order = '400000000001' material = 'MT00001' quantity = '15'
      plant = '0001' start_d = '20240101' finish_d = '20240102' )
    ( prod_order = '400000000002' material = 'MT00002' quantity = '20'
      plant = '0002' start_d = '20240101' finish_d = '20240102' )
    ( prod_order = '400000000003' material = 'MT00003' quantity = '300'
      plant = '0001' start_d = '20240101' finish_d = '20240102' )
    ( prod_order = '400000000004' material = 'MT00003' quantity = '150'
      plant = '0002' start_d = '20240103' finish_d = '20240105' )
    ( prod_order = '400000000005' material = 'MT00002' quantity = '25'
      plant = '0001' start_d = '20240103' finish_d = '20240105' )
    ( prod_order = '400000000006' material = 'MT00001' quantity = '80'
      plant = '0002' start_d = '20240103' finish_d = '20240105' )
    ( prod_order = '400000000007' material = 'MT00003' quantity = '70'
      plant = '0001' start_d = '20240106' finish_d = '20240108' )
    ( prod_order = '400000000008' material = 'MT00003' quantity = '45'
      plant = '0002' start_d = '20240106' finish_d = '20240108' )
    ( prod_order = '400000000009' material = 'MT00002' quantity = '30'
      plant = '0001' start_d = '20240106' finish_d = '20240108' )
    ( prod_order = '400000000010' material = 'MT00002' quantity = '100'
      plant = '0002' start_d = '20240107' finish_d = '20240109' )

    ).

    "Delete possible entries; insert new entries
    DELETE FROM ztpp_po_case.
    INSERT ztpp_po_case FROM TABLE @lt_po_case.

    IF sy-subrc EQ 0.
      out->write( |Production Orders: { sy-dbcnt } Inserted| ).
    ENDIF.

    lt_sto = VALUE #(
    ( sto = '500000000001' material = 'MT00001' quantity = '8'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240102' sto_close = 'X' )
    ( sto = '500000000002' material = 'MT00001' quantity = '10'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240103' sto_close = 'X' )
    ( sto = '500000000003' material = 'MT00003' quantity = '15'
      sup_plant = '0001' rec_plant = '0001' requir_d = '20240103' sto_close = '' )
    ( sto = '500000000004' material = 'MT00003' quantity = '25'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240106' sto_close = '' )
    ( sto = '500000000005' material = 'MT00003' quantity = '11'
      sup_plant = '0002' rec_plant = '0002' requir_d = '20240106' sto_close = '' )
    ( sto = '500000000006' material = 'MT00002' quantity = '7'
      sup_plant = '0001' rec_plant = '0001' requir_d = '20240106' sto_close = '' )
    ( sto = '500000000007' material = 'MT00001' quantity = '35'
      sup_plant = '0002' rec_plant = '0002' requir_d = '20240106' sto_close = '' )
    ( sto = '500000000008' material = 'MT00002' quantity = '100'
      sup_plant = '0002' rec_plant = '0002' requir_d = '20240106' sto_close = '' )
    ( sto = '500000000009' material = 'MT00002' quantity = '80'
      sup_plant = '0001' rec_plant = '0001' requir_d = '20240107' sto_close = '' )
    ( sto = '500000000010' material = 'MT00003' quantity = '16'
      sup_plant = '0001' rec_plant = '0001' requir_d = '20240107' sto_close = 'X' )
    ( sto = '500000000011' material = 'MT00001' quantity = '22'
      sup_plant = '0002' rec_plant = '0002' requir_d = '20240107' sto_close = 'X' )
    ( sto = '500000000012' material = 'MT00002' quantity = '18'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240107' sto_close = 'X' )
    ( sto = '500000000013' material = 'MT00003' quantity = '15'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240107' sto_close = '' )
    ( sto = '500000000014' material = 'MT00001' quantity = '30'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240107' sto_close = 'X' )
    ( sto = '500000000015' material = 'MT00001' quantity = '10'
      sup_plant = '0002' rec_plant = '0002' requir_d = '20240107' sto_close = '' )
    ( sto = '500000000016' material = 'MT00003' quantity = '5'
      sup_plant = '0002' rec_plant = '0002' requir_d = '20240108' sto_close = '' )
    ( sto = '500000000017' material = 'MT00003' quantity = '55'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240108' sto_close = '' )
    ( sto = '500000000018' material = 'MT00001' quantity = '25'
      sup_plant = '0001' rec_plant = '0001' requir_d = '20240108' sto_close = 'X' )
    ( sto = '500000000019' material = 'MT00001' quantity = '10'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240108' sto_close = 'X' )
    ( sto = '500000000020' material = 'MT00002' quantity = '18'
      sup_plant = '0001' rec_plant = '0002' requir_d = '20240108' sto_close = '' ) ).

    "Delete possible entries; insert new entries
    DELETE FROM ztpp_sto_case.
    INSERT ztpp_sto_case FROM TABLE @lt_sto.

    IF sy-subrc EQ 0.
      out->write( |Stock Transport Order: { sy-dbcnt } Inserted| ).
    ENDIF.

    lt_stock = VALUE #(
    ( material = 'MT00001' plant = '0001' quantity = '20' issued_date = '20240108'
      name = 'This is name for material MT00001' plantname = 'This is Plant 0001' )
    ( material = 'MT00001' plant = '0002' quantity = '2' issued_date = '20240108'
      name = 'This is name for material MT00001' plantname = 'This is Plant 0002' )
    ( material = 'MT00002' plant = '0001' quantity = '17' issued_date = '20240107'
      name = 'This is name for material MT00002' plantname = 'This is Plant 0001' )
    ( material = 'MT00002' plant = '0002' quantity = '0'  issued_date = '20240108'
      name = 'This is name for material MT00002' plantname = 'This is Plant 0002' )
    ( material = 'MT00003' plant = '0001' quantity = '10' issued_date = '20240107'
      name = 'This is name for material MT00003' plantname = 'This is Plant 0001' )
    ( material = 'MT00003' plant = '0002' quantity = '35' issued_date = '20240108'
      name = 'This is name for material MT00003' plantname = 'This is Plant 0002' ) ).

    "Delete possible entries; insert new entries
    DELETE FROM ztpp_stock_case.
    INSERT ztpp_stock_case FROM TABLE @lt_stock.

    IF sy-subrc EQ 0.
      out->write( |Stock: { sy-dbcnt } Inserted| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
