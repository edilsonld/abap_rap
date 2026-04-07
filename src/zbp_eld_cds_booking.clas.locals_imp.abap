CLASS lhc_yeld_cds_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsup FOR NUMBERING
      IMPORTING entities FOR CREATE yeld_cds_booking\_Bookingsup.

ENDCLASS.

CLASS lhc_yeld_cds_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsup.
    DATA: max_booking_suppl_id TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF yeld_cds_travel IN LOCAL MODE
        ENTITY yeld_cds_booking BY \_bookingSup
        FROM CORRESPONDING #( entities )
        LINK DATA(lt_booking_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.
      max_booking_suppl_id = REDUCE #( INIT max = CONV /dmo/booking_supplement_id('0')
                                       FOR booksuppl IN lt_booking_supplements USING KEY entity
                                                                               WHERE ( source-TravelId = <booking_group>-TravelId AND
                                                                                       source-BookingId = <booking_group>-BookingId )
                                       NEXT max = COND /dmo/booking_supplement_id( WHEN booksuppl-target-BookingSupplementId > max THEN booksuppl-target-BookingSupplementId
                                                                                   ELSE max ) ).

      max_booking_suppl_id = REDUCE #( INIT max = max_booking_suppl_id
                                             FOR entity IN entities USING KEY entity
                                                                    WHERE ( TravelId = <booking_group>-TravelId AND
                                                                            BookingId = <booking_group>-BookingId )
                                             FOR target IN entity-%target
                                             NEXT max = COND /dmo/booking_supplement_id( WHEN target-BookingSupplementId > max THEN target-BookingSupplementId
                                                                                         ELSE max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>) USING KEY entity WHERE TravelId = <booking_group>-TravelId AND
                                                                                  BookingId = <booking_group>-BookingId.
        LOOP AT <fs_entity>-%target ASSIGNING FIELD-SYMBOL(<bookingsup>).
          APPEND CORRESPONDING #( <bookingsup> ) TO mapped-yeld_cds_booking_sup ASSIGNING FIELD-SYMBOL(<mapp>).
          IF <mapp> IS ASSIGNED AND <mapp>-BookingSupplementId IS INITIAL.
            <mapp>-BookingSupplementId = max_booking_suppl_id + 1.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
