CLASS zeld_cl_operations DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zeld_cl_operations IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " read entidade simples
    "READ ENTITY yeld_cds_travel
    "    ALL FIELDS WITH VALUE #( ( %key-TravelId = '00004138') )
    "RESULT DATA(lt_travel)
    "FAILED DATA(lt_fail)
    "REPORTED DATA(lt_report).

    "out->write( data = lt_travel ).

    "if lt_fail is not inITIAL.
    "  out->write( data = lt_fail ).
    "endif.

    "if lt_report is not inITIAL.
    "  out->write( data = lt_report ).
    "endif.

    MODIFY ENTITY yeld_cds_travel
      CREATE FROM VALUE #( ( %cid = 'cid'
                             %data-BeginDate = '20260430'
                             %control-BeginDate = if_abap_behv=>mk-on ) )
    FAILED DATA(lt_fail)
    REPORTED DATA(lt_report)
    MAPPED DATA(lt_mapp).

    IF lt_fail IS NOT INITIAL AND lt_report IS NOT INITIAL.
      COMMIT ENTITIES.
    ELSE.
      out->write( data = lt_fail ).
      out->write( data = lt_report ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
