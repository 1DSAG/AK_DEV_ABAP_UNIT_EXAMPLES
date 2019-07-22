"! <p class="shorttext synchronized" lang="en">Test Double for BOPF Read</p>
CLASS zcl_td_bobf_frw_read DEFINITION
  PUBLIC
  CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    INTERFACES /bobf/if_frw_read.

    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "! @parameter ir_td_bobf_frw_read | Test double for read instance to double calls.
    METHODS constructor IMPORTING ir_td_bobf_frw_read TYPE REF TO /bobf/if_frw_read OPTIONAL.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Parameter structure type for method COMPARE</p>
      BEGIN OF gty_s_par_compare,
        iv_node_key        TYPE /bobf/obm_node_key,
        it_key             TYPE /bobf/t_frw_key,
        iv_fill_attributes TYPE boole_d,
        iv_scope           TYPE /bobf/frw_scope,
      END OF gty_s_par_compare,

      "! <p class="shorttext synchronized" lang="en">Parameter table type for method COMPARE</p>
      gty_t_par_compare TYPE STANDARD TABLE OF gty_s_par_compare WITH DEFAULT KEY,

      "! <p class="shorttext synchronized" lang="en">Parameter structure type for method CONVERT_ALTERN_KEY</p>
      BEGIN OF gty_s_par_convert_altern_key,
        iv_node_key          TYPE /bobf/obm_node_key,
        iv_altkey_key        TYPE /bobf/obm_altkey_key,
        iv_target_altkey_key TYPE /bobf/obm_altkey_key,
        iv_before_image      TYPE boole_d,
        iv_invalidate_cache  TYPE boole_d,
      END OF gty_s_par_convert_altern_key,

      "! <p class="shorttext synchronized" lang="en">Parameter table type for method CONVERT_ALTERN_KEY</p>
      gty_t_par_convert_altern_key TYPE STANDARD TABLE OF gty_s_par_convert_altern_key WITH DEFAULT KEY,

      "! <p class="shorttext synchronized" lang="en">Parameter structure type for method GET_ROOT_KEY</p>
      BEGIN OF gty_s_par_get_root_key,
        iv_node         TYPE /bobf/obm_node_key,
        it_key          TYPE /bobf/t_frw_key,
        iv_before_image TYPE boole_d,
      END OF gty_s_par_get_root_key,

      "! <p class="shorttext synchronized" lang="en">Parameter table type for method GET_ROOT_KEY</p>
      gty_t_par_get_root_key TYPE STANDARD TABLE OF gty_s_par_get_root_key WITH DEFAULT KEY,

      "! <p class="shorttext synchronized" lang="en">Parameter structure type for method RETRIEVE</p>
      BEGIN OF gty_s_par_retrieve,
        iv_node                 TYPE /bobf/obm_node_key,
        it_key                  TYPE /bobf/t_frw_key,
        iv_before_image         TYPE boole_d,
        iv_fill_data            TYPE boole_d,
        it_requested_attributes TYPE /bobf/t_frw_name,
      END OF gty_s_par_retrieve,

      "! <p class="shorttext synchronized" lang="en">Parameter table type for method RETRIEVE</p>
      gty_t_par_retrieve TYPE STANDARD TABLE OF gty_s_par_retrieve WITH DEFAULT KEY,

      "! <p class="shorttext synchronized" lang="en">Parameter structure type for method RETRIEVE_BY_ASSOCIATION</p>
      BEGIN OF gty_s_par_retrieve_by_assoc,
        iv_node                 TYPE /bobf/obm_node_key,
        it_key                  TYPE /bobf/t_frw_key,
        iv_association          TYPE /bobf/obm_assoc_key,
        is_parameters           TYPE REF TO data,
        it_filtered_attributes  TYPE /bobf/t_frw_name,
        iv_fill_data            TYPE boole_d,
        iv_before_image         TYPE boole_d,
        it_requested_attributes TYPE /bobf/t_frw_name,
      END OF gty_s_par_retrieve_by_assoc,

      "! <p class="shorttext synchronized" lang="en">Parameter table type for method RETRIEVE_BY_ASSOCIATION</p>
      gty_t_par_retrieve_by_assoc TYPE STANDARD TABLE OF gty_s_par_retrieve_by_assoc WITH DEFAULT KEY.

    DATA:
      "! <p class="shorttext synchronized" lang="en">Assertion values</p>
      BEGIN OF ms_assert,

        "! <p class="shorttext synchronized" lang="en">Assertion values for method COMPARE</p>
        BEGIN OF compare,
          called     TYPE abap_bool,
          calls      TYPE int4,
          parameters TYPE gty_t_par_compare,
        END OF compare,

        "! <p class="shorttext synchronized" lang="en">Assertion values for method CONVERT_ALTERN_KEY</p>
        BEGIN OF convert_altern_key,
          called     TYPE abap_bool,
          calls      TYPE int4,
          parameters TYPE gty_t_par_convert_altern_key,
        END OF convert_altern_key,

        "! <p class="shorttext synchronized" lang="en">Assertion values for method GET_ROOT_KEY</p>
        BEGIN OF get_root_key,
          called     TYPE abap_bool,
          calls      TYPE int4,
          parameters TYPE gty_t_par_get_root_key,
        END OF get_root_key,

        "! <p class="shorttext synchronized" lang="en">Assertion values for method RETRIEVE</p>
        BEGIN OF retrieve,
          called     TYPE abap_bool,
          calls      TYPE int4,
          parameters TYPE gty_t_par_retrieve,
        END OF retrieve,

        "! <p class="shorttext synchronized" lang="en">Assertion values for method RETRIEVE_BY_ASSOCIATION</p>
        BEGIN OF retrieve_by_association,
          called     TYPE abap_bool,
          calls      TYPE int4,
          parameters TYPE gty_t_par_retrieve_by_assoc,
        END OF retrieve_by_association,

      END OF ms_assert.

  PROTECTED SECTION.
  PRIVATE SECTION.
    "! <p class="shorttext synchronized" lang="en">Test double for read instance to double calls</p>
    DATA mr_td_bobf_frw_read TYPE REF TO /bobf/if_frw_read.

    "! <p class="shorttext synchronized" lang="en">Create a global data reference for a local data reference</p>
    "! @parameter ir_data | "! <p class="shorttext synchronized" lang="en">Local data reference</p>
    "! @parameter rr_data | "! <p class="shorttext synchronized" lang="en">Global data reference</p>
    CLASS-METHODS create_global_data_ref
      IMPORTING
        ir_data        TYPE REF TO data
      RETURNING
        VALUE(rr_data) TYPE REF TO data.
ENDCLASS.


CLASS zcl_td_bobf_frw_read IMPLEMENTATION.

  METHOD constructor.
    mr_td_bobf_frw_read = COND #( WHEN ir_td_bobf_frw_read IS BOUND
                                  THEN ir_td_bobf_frw_read
                                  ELSE CAST /bobf/if_frw_read( cl_abap_testdouble=>create( '/BOBF/IF_FRW_READ' ) ) ).
  ENDMETHOD.

  METHOD /bobf/if_frw_read~compare.
    ms_assert-compare = VALUE #( BASE ms_assert-compare
                                 called = abap_true
                                 calls = ms_assert-compare-calls + 1
                                 parameters = VALUE #( BASE ms_assert-compare-parameters
                                                       ( iv_node_key = iv_node_key
                                                         it_key = it_key
                                                         iv_fill_attributes = iv_fill_attributes
                                                         iv_scope = iv_scope ) ) ).

    DATA(lt_param) = VALUE abap_parmbind_tab(
      ( name = 'IV_NODE_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( iv_node_key ) )
      ( name = 'IT_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( it_key ) )
      ( name = 'EO_CHANGE' kind = cl_abap_objectdescr=>importing value = REF #( eo_change ) ) ).

    IF iv_fill_attributes IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_FILL_ATTRIBUTES' kind = cl_abap_objectdescr=>exporting value = REF #( iv_fill_attributes ) ) ).
    ENDIF.

    IF iv_scope IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_SCOPE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_scope ) ) ).
    ENDIF.

    CALL METHOD mr_td_bobf_frw_read->('COMPARE')
      PARAMETER-TABLE lt_param.
  ENDMETHOD.

  METHOD /bobf/if_frw_read~convert_altern_key.
    ms_assert-convert_altern_key = VALUE #( BASE ms_assert-convert_altern_key
                                            called = abap_true
                                            calls = ms_assert-convert_altern_key-calls + 1
                                            parameters = VALUE #( BASE ms_assert-convert_altern_key-parameters
                                                                  ( iv_node_key = iv_node_key
                                                                    iv_altkey_key = iv_altkey_key
                                                                    iv_target_altkey_key = iv_target_altkey_key
                                                                    iv_before_image = iv_before_image
                                                                    iv_invalidate_cache = iv_invalidate_cache ) ) ).

    DATA(lt_param) = VALUE abap_parmbind_tab(
      ( name = 'IV_NODE_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( iv_node_key ) )
      ( name = 'IV_ALTKEY_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( iv_altkey_key ) )
      ( name = 'ET_RESULT' kind = cl_abap_objectdescr=>importing value = REF #( et_result ) )
      ( name = 'ET_KEY' kind = cl_abap_objectdescr=>importing value = REF #( et_key ) ) ).

    IF iv_target_altkey_key IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_TARGET_ALTKEY_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( iv_target_altkey_key ) ) ).
    ENDIF.

    IF it_key IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IT_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( it_key ) ) ).
    ENDIF.

    IF iv_before_image IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_BEFORE_IMAGE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_before_image ) ) ).
    ENDIF.

    IF iv_invalidate_cache IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_INVALIDATE_CACHE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_invalidate_cache ) ) ).
    ENDIF.

    CALL METHOD mr_td_bobf_frw_read->('CONVERT_ALTERN_KEY')
      PARAMETER-TABLE lt_param.
  ENDMETHOD.

  METHOD /bobf/if_frw_read~get_root_key.
    ms_assert-get_root_key = VALUE #( BASE ms_assert-get_root_key
                                      called = abap_true
                                      calls = ms_assert-get_root_key-calls + 1
                                      parameters = VALUE #( BASE ms_assert-get_root_key-parameters
                                                            ( iv_node = iv_node
                                                              it_key = it_key
                                                              iv_before_image = iv_before_image ) ) ).

    DATA(lt_param) = VALUE abap_parmbind_tab(
      ( name = 'IV_NODE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_node ) )
      ( name = 'IT_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( it_key ) )
      ( name = 'ET_TARGET_KEY' kind = cl_abap_objectdescr=>importing value = REF #( et_target_key ) )
      ( name = 'ET_KEY_LINK' kind = cl_abap_objectdescr=>importing value = REF #( et_key_link ) )
      ( name = 'ET_FAILED_KEY' kind = cl_abap_objectdescr=>importing value = REF #( et_failed_key ) ) ).

    IF iv_before_image IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_BEFORE_IMAGE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_before_image ) ) ).
    ENDIF.

    CALL METHOD mr_td_bobf_frw_read->('GET_ROOT_KEY')
      PARAMETER-TABLE lt_param.
  ENDMETHOD.

  METHOD /bobf/if_frw_read~retrieve.
    ms_assert-retrieve = VALUE #( BASE ms_assert-retrieve
                                  called = abap_true
                                  calls = ms_assert-retrieve-calls + 1
                                  parameters = VALUE #( BASE ms_assert-retrieve-parameters
                                                        ( iv_node = iv_node
                                                          it_key = it_key
                                                          iv_before_image = iv_before_image
                                                          iv_fill_data = iv_fill_data
                                                          it_requested_attributes = it_requested_attributes ) ) ).

    DATA(lt_param) = VALUE abap_parmbind_tab(
      ( name = 'IV_NODE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_node ) )
      ( name = 'IT_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( it_key ) )
      ( name = 'EO_MESSAGE' kind = cl_abap_objectdescr=>importing value = REF #( eo_message ) )
      ( name = 'ET_DATA' kind = cl_abap_objectdescr=>importing value = REF #( et_data ) )
      ( name = 'ET_FAILED_KEY' kind = cl_abap_objectdescr=>importing value = REF #( et_failed_key ) )
      ( name = 'ET_NODE_CAT' kind = cl_abap_objectdescr=>importing value = REF #( et_node_cat ) ) ).

    IF iv_before_image IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_BEFORE_IMAGE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_before_image ) ) ).
    ENDIF.

    IF iv_fill_data IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_FILL_DATA' kind = cl_abap_objectdescr=>exporting value = REF #( iv_fill_data ) ) ).
    ENDIF.

    IF it_requested_attributes IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IT_REQUESTED_ATTRIBUTES' kind = cl_abap_objectdescr=>exporting value = REF #( it_requested_attributes ) ) ).
    ENDIF.

    CALL METHOD mr_td_bobf_frw_read->('RETRIEVE')
      PARAMETER-TABLE lt_param.
  ENDMETHOD.

  METHOD /bobf/if_frw_read~retrieve_by_association.
    ms_assert-retrieve_by_association = VALUE #( BASE ms_assert-retrieve_by_association
                                                 called = abap_true
                                                 calls = ms_assert-retrieve_by_association-calls + 1
                                                 parameters = VALUE #( BASE ms_assert-retrieve_by_association-parameters
                                                                       ( iv_node = iv_node
                                                                         it_key = it_key
                                                                         iv_association = iv_association
                                                                         is_parameters = create_global_data_ref( is_parameters )
                                                                         it_filtered_attributes = it_filtered_attributes
                                                                         iv_fill_data = iv_fill_data
                                                                         iv_before_image = iv_before_image
                                                                         it_requested_attributes = it_requested_attributes ) ) ).

    DATA(lt_param) = VALUE abap_parmbind_tab(
      ( name = 'IV_NODE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_node ) )
      ( name = 'IT_KEY' kind = cl_abap_objectdescr=>exporting value = REF #( it_key ) )
      ( name = 'IV_ASSOCIATION' kind = cl_abap_objectdescr=>exporting value = REF #( iv_association ) )
      ( name = 'EO_MESSAGE' kind = cl_abap_objectdescr=>importing value = REF #( eo_message ) )
      ( name = 'ET_DATA' kind = cl_abap_objectdescr=>importing value = REF #( et_data ) )
      ( name = 'ET_KEY_LINK' kind = cl_abap_objectdescr=>importing value = REF #( et_key_link ) )
      ( name = 'ET_TARGET_KEY' kind = cl_abap_objectdescr=>importing value = REF #( et_target_key ) )
      ( name = 'ET_FAILED_KEY' kind = cl_abap_objectdescr=>importing value = REF #( et_failed_key ) ) ).

    IF is_parameters IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IS_PARAMETERS' kind = cl_abap_objectdescr=>exporting value = REF #( is_parameters ) ) ).
    ENDIF.

    IF it_filtered_attributes IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IT_FILTERED_ATTRIBUTES' kind = cl_abap_objectdescr=>exporting value = REF #( it_filtered_attributes ) ) ).
    ENDIF.

    IF iv_fill_data IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_FILL_DATA' kind = cl_abap_objectdescr=>exporting value = REF #( iv_fill_data ) ) ).
    ENDIF.

    IF iv_before_image IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IV_BEFORE_IMAGE' kind = cl_abap_objectdescr=>exporting value = REF #( iv_before_image ) ) ).
    ENDIF.

    IF it_requested_attributes IS SUPPLIED.
      lt_param = VALUE #( BASE lt_param ( name = 'IT_REQUESTED_ATTRIBUTES' kind = cl_abap_objectdescr=>exporting value = REF #( it_requested_attributes ) ) ).
    ENDIF.

    CALL METHOD mr_td_bobf_frw_read->('RETRIEVE_BY_ASSOCIATION')
      PARAMETER-TABLE lt_param.
  ENDMETHOD.

  METHOD create_global_data_ref.
    CLEAR rr_data.

    IF ir_data IS INITIAL.
      RETURN.
    ENDIF.

    FIELD-SYMBOLS <lr_source> TYPE any.
    FIELD-SYMBOLS <lr_target> TYPE any.

    DATA(lr_handle) = CAST cl_abap_datadescr( cl_abap_typedescr=>describe_by_data_ref( ir_data ) ).

    CREATE DATA rr_data TYPE HANDLE lr_handle. " created reference is in heap
    ASSIGN ir_data->* TO <lr_source>.
    ASSIGN rr_data->* TO <lr_target>.
    <lr_target> = <lr_source>.
  ENDMETHOD.

ENDCLASS.
