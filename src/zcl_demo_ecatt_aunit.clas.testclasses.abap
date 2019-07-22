*"* use this source file for your ABAP unit test classes
CLASS lcl_test DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS: driven_by_ecattdata FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD driven_by_ecattdata.
    FIELD-SYMBOLS <lt_matdoc> TYPE nsdm_t_matdoc.
    DATA(lr_ecatt_api) = cl_apl_ecatt_tdc_api=>get_instance( i_testdatacontainer = 'ZDEMO_ECATT_AUNIT'  ).

    DATA(lt_test_data) = lr_ecatt_api->get_tdc_content( ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_test_data ).

    LOOP AT lt_test_data INTO DATA(ls_test_data) WHERE varname NE 'ECATTDEFAULT'.
      DATA(ls_matdoc_param) = ls_test_data-paramtab[ parname = 'MATDOC' ].
      ASSIGN ls_matdoc_param-value_ref->* TO <lt_matdoc>.

      cl_abap_unit_assert=>assert_not_initial(
          act              = <lt_matdoc>
          msg              = |ERROR in Variant { ls_test_data-varname }|
          quit             = if_aunit_constants=>quit-no ).

      UNASSIGN <lt_matdoc>.
      CLEAR ls_matdoc_param.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
