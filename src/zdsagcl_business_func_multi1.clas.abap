"! <p class="shorttext synchronized" lang="en">Demo Implementation</p>
CLASS zdsagcl_business_func_multi1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_business_function_multiple.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zdsagcl_business_func_multi1 IMPLEMENTATION.
  METHOD zif_business_function_multiple~doit.

  ENDMETHOD.

ENDCLASS.
