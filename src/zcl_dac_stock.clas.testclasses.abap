*"* use this source file for your ABAP unit test classes
CLASS lcl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      gr_environment TYPE REF TO if_osql_test_environment.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.

    TYPES: tt_stock TYPE STANDARD TABLE OF zstock.

    DATA mr_cut TYPE REF TO zif_dac_stock.

    METHODS setup.

    METHODS creates FOR TESTING RAISING cx_static_check.
    METHODS changes FOR TESTING RAISING cx_static_check.
    METHODS deletes FOR TESTING RAISING cx_static_check.


ENDCLASS.


CLASS lcl_test IMPLEMENTATION.

  METHOD class_setup.
    gr_environment = cl_osql_test_environment=>create(
        i_dependency_list = VALUE #(
            ( 'ZSTOCK' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    gr_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    mr_cut = NEW zcl_dac_stock( ).
    gr_environment->clear_doubles( ).
  ENDMETHOD.


  METHOD changes.
    DATA lt_double_stock TYPE tt_stock.
    lt_double_stock = VALUE #(
        ( uuid = '024D418489721EE8B1F8DBAA9E475A2A'  batch = '4711' )
        ( uuid = '024D418489721EE8B1F8DBAA9E475A2B'  batch = '4712' )
    ).
    gr_environment->insert_test_data( lt_double_stock ).

    DATA lt_act_stock TYPE zstock_t.
    DATA(lt_exp_stock) = VALUE zstock_t(
             ( uuid = '024D418489721EE8B1F8DBAA9E475A2A'  batch = '4711' )
             ( uuid = '024D418489721EE8B1F8DBAA9E475A2B'  batch = '4712' ) ).
    SORT lt_exp_stock BY uuid.

    mr_cut->change( lt_exp_stock ).

    SELECT uuid, batch FROM zstock
    INTO CORRESPONDING FIELDS OF TABLE @lt_act_stock
      WHERE uuid = '024D418489721EE8B1F8DBAA9E475A2A'
         OR uuid = '024D418489721EE8B1F8DBAA9E475A2B'
         ORDER BY uuid.

    cl_abap_unit_assert=>assert_equals(
        act = lt_act_stock
        exp = lt_exp_stock ).

  ENDMETHOD.

  METHOD creates.
    DATA lt_act_stock TYPE zstock_t.
    DATA(lt_exp_stock) = VALUE zstock_t(
             ( uuid = '024D418489721EE8B1F8DBAA9E475A2A'  batch = 'UTI' )
             ( uuid = '024D418489721EE8B1F8DBAA9E475A2B'  batch = 'UT2' ) ).
    SORT lt_exp_stock BY uuid.

    mr_cut->create( lt_exp_stock ).

    SELECT uuid, batch FROM zstock
    INTO CORRESPONDING FIELDS OF TABLE @lt_act_stock
      WHERE uuid = '024D418489721EE8B1F8DBAA9E475A2A'
         OR uuid = '024D418489721EE8B1F8DBAA9E475A2B'
         ORDER BY uuid.

    cl_abap_unit_assert=>assert_equals(
        act = lt_act_stock
        exp = lt_exp_stock ).
  ENDMETHOD.

  METHOD deletes.
    DATA lt_act_stock TYPE zstock_t.

    DATA lt_exp_stock TYPE tt_stock.

    lt_exp_stock = VALUE #(
           ( uuid = '024D418489721EE8B1F8DBAA9E475A2A'  batch = 'ABC' )
           ( uuid = '024D418489721EE8B1F8DBAA9E475A2B'  batch = 'DEF' ) ).
    SORT lt_exp_stock BY uuid.

    gr_environment->insert_test_data( lt_exp_stock ).


    DATA lt_stock_keys TYPE zstock_t.
    lt_stock_keys = VALUE #( FOR ls_stock IN lt_exp_stock ( uuid = ls_stock-uuid ) ).

    mr_cut->delete( lt_exp_stock ).

    SELECT uuid, batch FROM zstock
    INTO CORRESPONDING FIELDS OF TABLE @lt_act_stock
      WHERE uuid = '024D418489721EE8B1F8DBAA9E475A2A'
         OR uuid = '024D418489721EE8B1F8DBAA9E475A2B'
         ORDER BY uuid.

    cl_abap_unit_assert=>assert_initial(
        act = lt_act_stock ).
  ENDMETHOD.



ENDCLASS.
