CLASS zeld_cl_carga_tabela DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zeld_cl_carga_tabela IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM yeld_booking_sup.
    COMMIT WORK.
    DELETE FROM yeld_booking.
    COMMIT WORK.
    DELETE FROM yeld_travel.
    COMMIT WORK.

    INSERT yeld_travel from ( select * from /dmo/travel_m ).
    COMMIT WORK.

    INSERT yeld_booking from ( select * from /dmo/booking_m ).
    COMMIT WORK.

    INSERT yeld_booking_sup from ( select * from /dmo/booksuppl_m ).
    COMMIT WORK.
  endmethod.

ENDCLASS.
