*"* use this source file for your ABAP unit test classes

CLASS lcl_abap_unit DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    CONSTANTS c_node_key TYPE /bobf/obm_node_key VALUE '1111111111111111'.

    DATA mt_key TYPE /bobf/t_frw_key.
    DATA mt_keyindex TYPE /bobf/t_frw_keyindex.
    DATA mt_keylink TYPE /bobf/t_frw_key_link.
    DATA mt_node_attribute TYPE /bobf/t_frw_name.

    DATA mr_message TYPE REF TO /bobf/if_frw_message.
    DATA mr_change TYPE REF TO /bobf/if_frw_change.

    DATA mr_td_bobf_frw_read TYPE REF TO /bobf/if_frw_read.
    DATA mr_cut TYPE REF TO zcl_td_bobf_frw_read.

    METHODS setup.
    METHODS teardown.

    METHODS test_call_compare FOR TESTING.
    METHODS test_call_convert_altern_key FOR TESTING.
    METHODS test_call_get_root_key FOR TESTING.
    METHODS test_call_retrieve FOR TESTING.
    METHODS test_call_ret_by_association FOR TESTING.
ENDCLASS.


CLASS lcl_abap_unit IMPLEMENTATION.

  METHOD setup.
    mr_td_bobf_frw_read = CAST /bobf/if_frw_read( cl_abap_testdouble=>create( '/BOBF/IF_FRW_READ' ) ).
    mr_cut = NEW #( ir_td_bobf_frw_read = mr_td_bobf_frw_read ).

    mr_message = /bobf/cl_frw_factory=>get_message( ).
    mr_change = /bobf/cl_frw_factory=>get_change( ).

    mt_key = VALUE #( ( key = c_node_key ) ).
    mt_keyindex = VALUE #( ( index = 1 key = c_node_key ) ).
    mt_keylink = VALUE #( ( source_key = c_node_key target_key = c_node_key ) ).
    mt_node_attribute = VALUE #( ( |DUMMY| ) ).
  ENDMETHOD.

  METHOD teardown.
    FREE mr_td_bobf_frw_read.
    FREE mr_cut.
  ENDMETHOD.

  METHOD test_call_compare.
    cl_abap_testdouble=>configure_call( mr_td_bobf_frw_read )->set_parameter( name = 'EO_CHANGE' value = mr_change ).

    mr_td_bobf_frw_read->compare(
      EXPORTING
        iv_node_key        = c_node_key
        it_key             = mt_key
        iv_fill_attributes = abap_true
        iv_scope           = /bobf/if_frw_c=>sc_scope_local ).

    mr_cut->/bobf/if_frw_read~compare(
      EXPORTING
        iv_node_key        = c_node_key
        it_key             = mt_key
        iv_fill_attributes = abap_true
        iv_scope           = /bobf/if_frw_c=>sc_scope_local
      IMPORTING
        eo_change          = DATA(lr_ret_change) ).

    cl_abap_unit_assert=>assert_true( mr_cut->ms_assert-compare-called ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-compare-calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-compare-parameters[ 1 ]-iv_node_key exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-compare-parameters[ 1 ]-it_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-compare-parameters[ 1 ]-iv_fill_attributes exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-compare-parameters[ 1 ]-iv_scope exp = /bobf/if_frw_c=>sc_scope_local ).
    cl_abap_unit_assert=>assert_equals( act = lr_ret_change exp = mr_change ).
  ENDMETHOD.

  METHOD test_call_convert_altern_key.
    DATA lt_ret_key TYPE /bobf/t_frw_key.

    cl_abap_testdouble=>configure_call( mr_td_bobf_frw_read )->set_parameter( name = 'ET_RESULT' value = mt_keyindex
                                                            )->set_parameter( name = 'ET_KEY' value = mt_key ).

    mr_td_bobf_frw_read->convert_altern_key(
      EXPORTING
        iv_node_key          = c_node_key
        iv_altkey_key        = c_node_key
        iv_target_altkey_key = /bobf/if_frw_c=>sc_alternative_key_key
        it_key               = mt_key
        iv_before_image      = abap_true
        iv_invalidate_cache  = abap_true ).

    mr_cut->/bobf/if_frw_read~convert_altern_key(
      EXPORTING
        iv_node_key          = c_node_key
        iv_altkey_key        = c_node_key
        iv_target_altkey_key = /bobf/if_frw_c=>sc_alternative_key_key
        it_key               = mt_key
        iv_before_image      = abap_true
        iv_invalidate_cache  = abap_true
      IMPORTING
        et_result            = DATA(lt_ret_result)
        et_key               = lt_ret_key ).

    cl_abap_unit_assert=>assert_true( mr_cut->ms_assert-convert_altern_key-called ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-convert_altern_key-calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-convert_altern_key-parameters[ 1 ]-iv_node_key exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-convert_altern_key-parameters[ 1 ]-iv_altkey_key exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-convert_altern_key-parameters[ 1 ]-iv_target_altkey_key exp = /bobf/if_frw_c=>sc_alternative_key_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-convert_altern_key-parameters[ 1 ]-iv_before_image exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-convert_altern_key-parameters[ 1 ]-iv_invalidate_cache exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_result exp = mt_keyindex ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_key exp = mt_key ).
  ENDMETHOD.

  METHOD test_call_get_root_key.
    cl_abap_testdouble=>configure_call( mr_td_bobf_frw_read )->set_parameter( name = 'ET_TARGET_KEY' value = mt_key
                                                            )->set_parameter( name = 'ET_KEY_LINK' value = mt_keylink
                                                            )->set_parameter( name = 'ET_FAILED_KEY' value = mt_key ).

    mr_td_bobf_frw_read->get_root_key(
      EXPORTING
        iv_node         = c_node_key
        it_key          = mt_key
        iv_before_image = abap_true ).

    mr_cut->/bobf/if_frw_read~get_root_key(
      EXPORTING
        iv_node         = c_node_key
        it_key          = mt_key
        iv_before_image = abap_true
      IMPORTING
        et_target_key   = DATA(lt_ret_target_key)
        et_key_link     = DATA(lt_ret_key_link)
        et_failed_key   = DATA(lt_ret_failed_key) ).

    cl_abap_unit_assert=>assert_true( mr_cut->ms_assert-get_root_key-called ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-get_root_key-calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-get_root_key-parameters[ 1 ]-iv_node exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-get_root_key-parameters[ 1 ]-it_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-get_root_key-parameters[ 1 ]-iv_before_image exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_target_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_key_link exp = mt_keylink ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_failed_key exp = mt_key ).
  ENDMETHOD.

  METHOD test_call_retrieve.
    DATA lt_ret_data TYPE /bobf/t_frw_key.

    DATA(lt_node_cat) = VALUE /bobf/t_frw_node_cat( ( key = c_node_key ) ).

    cl_abap_testdouble=>configure_call( mr_td_bobf_frw_read )->set_parameter( name = 'EO_MESSAGE' value = mr_message
                                                            )->set_parameter( name = 'ET_DATA' value = mt_key
                                                            )->set_parameter( name = 'ET_FAILED_KEY' value = mt_key
                                                            )->set_parameter( name = 'ET_NODE_CAT' value = lt_node_cat ).

    mr_td_bobf_frw_read->retrieve(
      EXPORTING
        iv_node                 = c_node_key
        it_key                  = mt_key
        iv_before_image         = abap_true
        iv_fill_data            = abap_true
        it_requested_attributes = mt_node_attribute ).

    mr_cut->/bobf/if_frw_read~retrieve(
      EXPORTING
        iv_node                 = c_node_key
        it_key                  = mt_key
        iv_before_image         = abap_true
        iv_fill_data            = abap_true
        it_requested_attributes = mt_node_attribute
      IMPORTING
        eo_message              = DATA(lr_ret_message)
        et_data                 = lt_ret_data
        et_failed_key           = DATA(lt_ret_failed_key)
        et_node_cat             = DATA(lt_ret_node_cat) ).

    cl_abap_unit_assert=>assert_true( mr_cut->ms_assert-retrieve-called ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve-calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve-parameters[ 1 ]-iv_node exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve-parameters[ 1 ]-it_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve-parameters[ 1 ]-iv_before_image exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve-parameters[ 1 ]-iv_fill_data exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve-parameters[ 1 ]-it_requested_attributes exp = mt_node_attribute ).
    cl_abap_unit_assert=>assert_equals( act = lr_ret_message exp = mr_message ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_data exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_failed_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_node_cat exp = lt_node_cat ).
  ENDMETHOD.

  METHOD test_call_ret_by_association.
    DATA lr_parameters TYPE REF TO data.
    DATA lt_ret_data TYPE /bobf/t_frw_key.

    cl_abap_testdouble=>configure_call( mr_td_bobf_frw_read )->set_parameter( name = 'EO_MESSAGE' value = mr_message
                                                            )->set_parameter( name = 'ET_DATA' value = mt_key
                                                            )->set_parameter( name = 'ET_KEY_LINK' value = mt_keylink
                                                            )->set_parameter( name = 'ET_TARGET_KEY' value = mt_key
                                                            )->set_parameter( name = 'ET_FAILED_KEY' value = mt_key ).

    mr_td_bobf_frw_read->retrieve_by_association(
      EXPORTING
        iv_node                 = c_node_key
        it_key                  = mt_key
        iv_association          = c_node_key
        is_parameters           = lr_parameters
        it_filtered_attributes  = mt_node_attribute
        iv_fill_data            = abap_true
        iv_before_image         = abap_true
        it_requested_attributes = mt_node_attribute ).

    mr_cut->/bobf/if_frw_read~retrieve_by_association(
      EXPORTING
        iv_node                 = c_node_key
        it_key                  = mt_key
        iv_association          = c_node_key
        is_parameters           = lr_parameters
        it_filtered_attributes  = mt_node_attribute
        iv_fill_data            = abap_true
        iv_before_image         = abap_true
        it_requested_attributes = mt_node_attribute
      IMPORTING
        eo_message              = DATA(lr_ret_message)
        et_data                 = lt_ret_data
        et_key_link             = DATA(lt_ret_key_link)
        et_target_key           = DATA(lt_ret_target_key)
        et_failed_key           = DATA(lt_ret_failed_key) ).

    cl_abap_unit_assert=>assert_true( mr_cut->ms_assert-retrieve_by_association-called ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-iv_node exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-it_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-iv_association exp = c_node_key ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-is_parameters exp = lr_parameters ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-it_filtered_attributes exp = mt_node_attribute ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-iv_fill_data exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-iv_before_image exp = abap_true ).
    cl_abap_unit_assert=>assert_equals( act = mr_cut->ms_assert-retrieve_by_association-parameters[ 1 ]-it_requested_attributes exp = mt_node_attribute ).
    cl_abap_unit_assert=>assert_equals( act = lr_ret_message exp = mr_message ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_data exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_key_link exp = mt_keylink ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_target_key exp = mt_key ).
    cl_abap_unit_assert=>assert_equals( act = lt_ret_failed_key exp = mt_key ).
  ENDMETHOD.

ENDCLASS.
