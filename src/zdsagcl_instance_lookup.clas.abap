"! <p class="shorttext synchronized" lang="en">Instance Lookup for a particular Interface</p>
"!
"! The class enables you to avoid direct wiring to particular classes
CLASS zdsagcl_instance_lookup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
            tt_object_ref TYPE STANDARD TABLE OF REF TO object WITH EMPTY KEY.

    "! <p class="shorttext synchronized" lang="en">Returns an instance to the particular interface</p>
    "!
    "! @parameter iv_interface | <p class="shorttext synchronized" lang="en">ABAP OO-Interface Name</p>
    "! @parameter if_reuse_instance | <p class="shorttext synchronized" lang="en">Controls, reusing the instance</p>
    "! @parameter rr_obj | <p class="shorttext synchronized" lang="en">Created object</p>
    CLASS-METHODS get_instance
      IMPORTING
        iv_interface      TYPE classname
        if_reuse_instance TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rr_obj)     TYPE REF TO object.

    "! <p class="shorttext synchronized" lang="en">Returns multiple instances to the particular</p>
    "! interface. With parameter <em>if_reuse_instance</em> you can control, if you want
    "! to use the instance as a singleton or to create a new instance every time
    "!
    "! @parameter iv_interface | <p class="shorttext synchronized" lang="en">ABAP OO-Interface Name</p>
    "! @parameter if_reuse_instance | <p class="shorttext synchronized" lang="en">Controls,reusing the instance</p>
    "! @parameter rt_obj | <p class="shorttext synchronized" lang="en">Created objects</p>
    CLASS-METHODS get_instances
      IMPORTING
        iv_interface      TYPE classname
        if_reuse_instance TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rt_obj)     TYPE tt_object_ref.

    "! <p class="shorttext synchronized" lang="en">Allows to inject for a particular interface a instance</p>
    "! Once, the instance is injected, it will be reused from the get()-methods, even if the
    "! <em>if_reuse_instance</em>-parameter is set to abap_false<
    "!
    "! @parameter iv_interface | <p class="shorttext synchronized" lang="en">ABAP OO-Interface Name</p>
    "! @parameter ir_instance | <p class="shorttext synchronized" lang="en">Instance to be injected</p>
    CLASS-METHODS inject
      IMPORTING
        iv_interface TYPE classname
        ir_instance  TYPE REF TO object.

    "! <p class="shorttext synchronized" lang="en">Cleans up the internal instances cache</p>
    CLASS-METHODS cleanup.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_register,
        interface   TYPE classname,
        classname   TYPE classname,
        instance    TYPE REF TO object,
        is_injected TYPE abap_bool,
      END OF ty_register.

    CLASS-DATA gt_register TYPE SORTED TABLE OF ty_register WITH NON-UNIQUE KEY interface.

    CLASS-METHODS load_register
      IMPORTING
        iv_interface TYPE classname.
ENDCLASS.



CLASS ZDSAGCL_INSTANCE_LOOKUP IMPLEMENTATION.


  METHOD cleanup.
    FREE gt_register.
  ENDMETHOD.


  METHOD get_instance.
    DATA(lt_objs) = get_instances(
        iv_interface      = iv_interface
        if_reuse_instance = if_reuse_instance ).
    ASSERT lines( lt_objs ) = 1.
    rr_obj = lt_objs[ 1 ].
  ENDMETHOD.


  METHOD get_instances.
    load_register( iv_interface ).

    LOOP AT gt_register ASSIGNING FIELD-SYMBOL(<ls_register>) WHERE interface = iv_interface.
      IF ( <ls_register>-instance IS INITIAL OR if_reuse_instance = abap_false ) AND
         <ls_register>-is_injected = abap_false.

        CREATE OBJECT <ls_register>-instance TYPE (<ls_register>-classname).
      ENDIF.
      APPEND <ls_register>-instance TO rt_obj.
    ENDLOOP.
  ENDMETHOD.


  METHOD inject.
    ASSIGN gt_register[ interface = iv_interface ] TO FIELD-SYMBOL(<ls_register>).
    IF sy-subrc = 0.
      <ls_register>-is_injected = abap_true.
      <ls_register>-instance = ir_instance.
    ELSE.
      INSERT VALUE #( interface   = iv_interface
                      instance    = ir_instance
                      is_injected = abap_true ) INTO TABLE gt_register.
    ENDIF.
  ENDMETHOD.


  METHOD load_register.
    IF NOT line_exists( gt_register[ interface = iv_interface ] ).
      DATA lt_tmp_register LIKE gt_register.
      SELECT clsname AS classname, refclsname AS interface FROM vseoimplem
        INTO CORRESPONDING FIELDS OF TABLE @lt_tmp_register
        WHERE refclsname = @iv_interface
          AND version   <> @seoc_version_inactive
          AND impabstrct = @abap_false
          AND state      = @seoc_state_implemented
          AND clsname LIKE 'ZDSAG%'. "#EC CI_SEL_NESTED "<---- Your namespace comes here!

      INSERT LINES OF lt_tmp_register INTO TABLE gt_register.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
