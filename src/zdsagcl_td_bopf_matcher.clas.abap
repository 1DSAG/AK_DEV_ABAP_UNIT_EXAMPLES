"! <p class="shorttext synchronized" lang="en">Matcher for BOPF classes</p>
CLASS zdsagcl_td_bopf_matcher DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_abap_testdouble_matcher.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS handle_do_modify
      IMPORTING
                ir_configured_arguments TYPE REF TO if_abap_testdouble_arguments
                ir_actual_arguments     TYPE REF TO if_abap_testdouble_arguments
      RETURNING VALUE(rf_result)        TYPE abap_bool
      .

    METHODS handle_update
      IMPORTING
                ir_configured_arguments TYPE REF TO if_abap_testdouble_arguments
                ir_actual_arguments     TYPE REF TO if_abap_testdouble_arguments
      RETURNING VALUE(rf_result)        TYPE abap_bool
      .
ENDCLASS.



CLASS zdsagcl_td_bopf_matcher IMPLEMENTATION.
  METHOD if_abap_testdouble_matcher~matches.

    CASE method_name.
      WHEN 'DO_MODIFY'.
        result = handle_do_modify(
            ir_configured_arguments = configured_arguments
            ir_actual_arguments     = actual_arguments
        ).
      WHEN 'UPDATE'.
        result = handle_update(
            ir_configured_arguments = configured_arguments
            ir_actual_arguments     = actual_arguments
        ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_do_modify.

    FIELD-SYMBOLS: <lt_act_modification> TYPE /bobf/t_frw_modification,
                   <lt_exp_modification> TYPE /bobf/t_frw_modification.

    rf_result = abap_false.

    DATA(lr_act_mod) = ir_actual_arguments->get_param_importing( 'it_modification' ) ##NO_TEXT.
    DATA(lr_exp_mod) = ir_configured_arguments->get_param_importing( 'it_modification' ) ##NO_TEXT.

    ASSIGN lr_act_mod->*  TO <lt_act_modification>.
    ASSIGN lr_exp_mod->* TO <lt_exp_modification>.


    IF <lt_act_modification> IS ASSIGNED AND <lt_exp_modification> IS ASSIGNED
      AND lines( <lt_act_modification> ) = lines( <lt_exp_modification> ).

      LOOP AT <lt_act_modification> ASSIGNING FIELD-SYMBOL(<ls_actual>).
        READ TABLE <lt_exp_modification> INDEX sy-tabix ASSIGNING FIELD-SYMBOL(<ls_expected>).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-association    exp = <ls_expected>-association ).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-source_key     exp = <ls_expected>-source_key ).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-source_node    exp = <ls_expected>-source_node ).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-node           exp = <ls_expected>-node        ).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-change_mode    exp = <ls_expected>-change_mode ).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-key            exp = <ls_expected>-key        ).
        cl_abap_unit_assert=>assert_equals( act = <ls_actual>-changed_fields exp = <ls_expected>-changed_fields ).

        ASSIGN <ls_actual>-data->*   TO FIELD-SYMBOL(<ls_actual_data>).
        ASSIGN <ls_expected>-data->* TO FIELD-SYMBOL(<ls_expected_data>).

        IF <ls_actual_data> IS ASSIGNED AND <ls_expected_data> IS ASSIGNED.
          cl_abap_unit_assert=>assert_equals( act = <ls_actual_data>  exp = <ls_expected_data>  ).
        ENDIF.
        UNASSIGN <ls_actual_data>.
        UNASSIGN <ls_expected_data>.
      ENDLOOP.

      rf_result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD handle_update.
    FIELD-SYMBOLS:
      <lr_act_outer_data> TYPE data,
      <lr_exp_outer_data> TYPE data.

    rf_result = abap_false.

    DATA(lr_act_node) = ir_actual_arguments->get_param_importing( 'iv_node' ) ##NO_TEXT.
    DATA(lr_exp_node) = ir_configured_arguments->get_param_importing( 'iv_node' ) ##NO_TEXT.

    ASSIGN lr_act_node->* TO FIELD-SYMBOL(<lv_act_node>).
    ASSIGN lr_exp_node->* TO FIELD-SYMBOL(<lv_exp_node>).

    IF <lv_act_node> IS NOT ASSIGNED OR <lv_exp_node> IS NOT ASSIGNED OR <lv_act_node> <> <lv_exp_node>.
      RETURN.
    ENDIF.


    DATA(lr_act_key) = ir_actual_arguments->get_param_importing( 'iv_key' ) ##NO_TEXT.
    DATA(lr_exp_key) = ir_configured_arguments->get_param_importing( 'iv_key' ) ##NO_TEXT.

    ASSIGN lr_act_key->* TO FIELD-SYMBOL(<lv_act_key>).
    ASSIGN lr_exp_key->* TO FIELD-SYMBOL(<lv_exp_key>).

    IF <lv_act_key> IS NOT ASSIGNED OR <lv_exp_key> IS NOT ASSIGNED OR <lv_act_key> <> <lv_exp_key>.
      RETURN.
    ENDIF.


    DATA(lr_act_data) = ir_actual_arguments->get_param_importing( 'is_data' ) ##NO_TEXT.
    DATA(lr_exp_data) = ir_configured_arguments->get_param_importing( 'is_data' ) ##NO_TEXT.

    ASSIGN lr_act_data->* TO <lr_act_outer_data>.
    ASSIGN <lr_act_outer_data>->* TO FIELD-SYMBOL(<ls_act_data>).
    ASSIGN lr_exp_data->* TO <lr_exp_outer_data>.
    ASSIGN <lr_exp_outer_data>->* TO FIELD-SYMBOL(<ls_exp_data>).

    IF <ls_act_data> IS ASSIGNED AND <ls_exp_data> IS ASSIGNED.
      cl_abap_unit_assert=>assert_equals( act = <ls_act_data> exp = <ls_exp_data> ).
      rf_result = abap_true.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
