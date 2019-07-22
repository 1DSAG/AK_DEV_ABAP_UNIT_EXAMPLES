*"* use this source file for your ABAP unit test classes
CLASS lcl_abap_unit DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS: setup.
    METHODS: teardown.

    METHODS: handles_do_modify FOR TESTING RAISING cx_static_check.
    METHODS: handles_update FOR TESTING RAISING cx_static_check.

    DATA: mr_cut TYPE REF TO zdsagcl_td_bopf_matcher.
ENDCLASS.


CLASS lcl_abap_unit IMPLEMENTATION.

  METHOD setup.
    mr_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mr_cut.
  ENDMETHOD.

  METHOD handles_do_modify.
    DATA:
      lr_modify_double  TYPE REF TO /bobf/if_frw_modify,
      lt_key            TYPE /bobf/t_frw_key,
      lt_root_key       TYPE /bobf/t_frw_key,
      lt_failed_key     TYPE /bobf/t_frw_key,
      ls_ctx            TYPE /bobf/s_frw_ctx_det,
      lt_failed_key_act TYPE /bobf/t_frw_key,
      lt_modification   TYPE /bobf/t_frw_modification.

    lr_modify_double ?= cl_abap_testdouble=>create( '/bobf/if_frw_modify' ).


    cl_abap_testdouble=>configure_call( double = lr_modify_double
         )->set_matcher( matcher = me->mr_cut
         )->and_expect( )->is_called_once( ).

    lr_modify_double->do_modify( it_modification = lt_modification ).

    " your business logic comes here

    cl_abap_unit_assert=>assert_equals(
      exp = lt_failed_key
      act = lt_failed_key_act
    ).

    cl_abap_testdouble=>verify_expectations( double = lr_modify_double ).

  ENDMETHOD.


  METHOD handles_update.
    DATA:
      lr_modify_double TYPE REF TO /bobf/if_frw_modify,
      lr_exp_update    TYPE REF TO data.

    cl_abap_testdouble=>configure_call(
      double = lr_modify_double
    )->set_matcher(  me->mr_cut )->and_expect( )->is_called_once( ).

    lr_modify_double->update(
     iv_node = '00000000000000000000000000000004' "<--- Your expected BOPF node comes here
     iv_key  = '00000000000000000000000000000004' "<--- The expected key from BOPF node instance comes here
     is_data = lr_exp_update
    ).

    " your business logic comes here


    cl_abap_testdouble=>verify_expectations( double = lr_modify_double ).
  ENDMETHOD.

ENDCLASS.
