*"* use this source file for your ABAP unit test classes
CLASS lcl_business_func_dummy DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES:
      zif_business_function_single PARTIALLY IMPLEMENTED.
ENDCLASS.

CLASS lcl_business_func_dummy IMPLEMENTATION.

ENDCLASS.

CLASS lcl_abap_unit DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS:
      teardown,

      "! Tests to simply get an instance for a particular interface
      "! @raising cx_static_check | Static Exception
      get_instance FOR TESTING RAISING cx_static_check,

      "! Tests the reusing of an instance
      "! @raising cx_static_check |Static Exception
      reuse_instance FOR TESTING RAISING cx_static_check,


      "! Tests if multiple instance for a particular interface could be retrieved
      "! @raising cx_static_check |Static Exception
      multiple_instances FOR TESTING RAISING cx_static_check,


      "! Tests to inject instances for a particular interface
      "! @raising cx_static_check |Static Exception
      can_inject_instances FOR TESTING RAISING cx_static_check,


      "! Tests to inject instances before an instance is retrieved already
      "! -> Could be most of the cases in a unit test
      "! @raising cx_static_check |Static Exception
      can_inject_upfront_usage FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS lcl_abap_unit IMPLEMENTATION.
  METHOD teardown.
    zdsagcl_instance_lookup=>cleanup( ).
  ENDMETHOD.

  METHOD get_instance.
    DATA(lr_business_function) = CAST zif_business_function_single( zdsagcl_instance_lookup=>get_instance( 'ZIF_BUSINESS_FUNCTION_SINGLE' ) ).
    cl_abap_unit_assert=>assert_bound( act = lr_business_function ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_business_function IS INSTANCE OF zif_business_function_single ) ).
  ENDMETHOD.

  METHOD reuse_instance.
    DATA(lr_business_function) = CAST zif_business_function_single(
       zdsagcl_instance_lookup=>get_instance( iv_interface = 'ZIF_BUSINESS_FUNCTION_SINGLE' ) ).

    DATA(lr_business_function2) = CAST zif_business_function_single(
            zdsagcl_instance_lookup=>get_instance( iv_interface      = 'ZIF_BUSINESS_FUNCTION_SINGLE'
                                               if_reuse_instance = abap_false ) ).

    cl_abap_unit_assert=>assert_false( xsdbool( lr_business_function = lr_business_function2  ) ).

    DATA(lt_obj_for_cache_busting) = zdsagcl_instance_lookup=>get_instances( 'ZIF_BUSINESS_FUNCTION_MULTIPLE' ).

    DATA(lr_business_function3) = CAST zif_business_function_single( zdsagcl_instance_lookup=>get_instance( 'ZIF_BUSINESS_FUNCTION_SINGLE' ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_business_function2 = lr_business_function3  ) ).
  ENDMETHOD.

  METHOD multiple_instances.
    DATA(lt_bf_date_obj) = zdsagcl_instance_lookup=>get_instances( 'ZIF_BUSINESS_FUNCTION_SINGLE' ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_bf_date_obj )  exp = 1 ).
    DATA(lr_business_function) = CAST zif_business_function_single( lt_bf_date_obj[ 1 ] ).

    cl_abap_unit_assert=>assert_bound( act = lr_business_function ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_business_function IS INSTANCE OF zif_business_function_single ) ).


    DATA(lt_audit_obj) = zdsagcl_instance_lookup=>get_instances( 'ZIF_BUSINESS_FUNCTION_MULTIPLE' ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_audit_obj ).

    DATA(lr_audit) = CAST zif_business_function_multiple( lt_audit_obj[ 1 ] ).
    cl_abap_unit_assert=>assert_bound( act = lr_audit ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_audit IS INSTANCE OF zif_business_function_multiple ) ).
  ENDMETHOD.

  METHOD can_inject_instances.
    DATA(lr_business_function) = CAST zif_business_function_single( zdsagcl_instance_lookup=>get_instance( 'ZIF_BUSINESS_FUNCTION_SINGLE' ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_business_function IS INSTANCE OF zif_business_function_single ) ).

    zdsagcl_instance_lookup=>inject(
        iv_interface = 'ZIF_BUSINESS_FUNCTION_SINGLE'
        ir_instance = NEW lcl_business_func_dummy( ) ) .

    DATA(lr_mocked_business_function) = CAST zif_business_function_single( zdsagcl_instance_lookup=>get_instance( 'ZIF_BUSINESS_FUNCTION_SINGLE' ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_mocked_business_function IS INSTANCE OF zif_business_function_single ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_mocked_business_function IS INSTANCE OF lcl_business_func_dummy ) ).
  ENDMETHOD.


  METHOD can_inject_upfront_usage.
    zdsagcl_instance_lookup=>inject(
        iv_interface = 'ZIF_BUSINESS_FUNCTION_SINGLE'
        ir_instance = NEW lcl_business_func_dummy( ) ) .

    DATA(lr_mocked_business_function) = CAST zif_business_function_single( zdsagcl_instance_lookup=>get_instance( 'ZIF_BUSINESS_FUNCTION_SINGLE' ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_mocked_business_function IS INSTANCE OF zif_business_function_single ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lr_mocked_business_function IS INSTANCE OF lcl_business_func_dummy ) ).
  ENDMETHOD.

ENDCLASS.
