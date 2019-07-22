"! <p class="shorttext synchronized" lang="en">CRUD interface for Stock</p>
INTERFACE zif_dac_stock
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">Create entity for Stock</p>
  "!
  "! @parameter it_stock | <p class="shorttext synchronized" lang="en">List of Entities</p>
  METHODS create
    IMPORTING
      !it_stock TYPE zstock_t .
  "! <p class="shorttext synchronized" lang="en">Change/Update entity for Stock</p>
  "!
  "! @parameter it_stock | <p class="shorttext synchronized" lang="en">List of Entities</p>
  METHODS change
    IMPORTING
      !it_stock TYPE zstock_t .
  "! <p class="shorttext synchronized" lang="en">Delete entity for Stock</p>
  "!
  "! @parameter it_stock | <p class="shorttext synchronized" lang="en">List of Entities</p>
  METHODS delete
    IMPORTING
      !it_stock TYPE zstock_t .

ENDINTERFACE.
