"! <p class="shorttext synchronized" lang="en">CRUD Operations for Stock</p>
CLASS zcl_dac_stock DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_dac_stock.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_dac_stock IMPLEMENTATION.


  METHOD zif_dac_stock~change.
    IF ( it_stock[] IS NOT INITIAL ).
      UPDATE zstock FROM TABLE it_stock[].                "#EC CI_SUBRC
    ENDIF.
  ENDMETHOD.


  METHOD zif_dac_stock~create.
    IF ( it_stock[] IS NOT INITIAL ).
      INSERT zstock FROM TABLE it_stock[].                "#EC CI_SUBRC
    ENDIF.
  ENDMETHOD.


  METHOD zif_dac_stock~delete.
    IF ( it_stock[] IS NOT INITIAL ).
      DELETE zstock FROM TABLE it_stock[].                "#EC CI_SUBRC
    ENDIF.
  ENDMETHOD.
ENDCLASS.
