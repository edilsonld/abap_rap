CLASS lhc_YELD_CDS_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR yeld_cds_travel RESULT result.
    METHODS copia FOR MODIFY
      IMPORTING keys FOR ACTION yeld_cds_travel~copia.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE yeld_cds_travel\_booking.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE yeld_cds_travel.

ENDCLASS.

CLASS lhc_YELD_CDS_TRAVEL IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA: lv_last_number TYPE nrlevel,
          lv_quantity    TYPE nrquan.
    TRY.
        TRY.
            " busca o último numero
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr       = '01'
                object            = '/DMO/TRV_M' "isso é um range, ligado na tabela
                quantity          = 1
              IMPORTING
                number            = lv_last_number
                returned_quantity = lv_quantity
            ).
          CATCH cx_number_ranges INTO DATA(exc_01).

            LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity_01>).
              APPEND VALUE #( %cid = <fs_entity_01>-%cid
                              %key = <fs_entity_01>-%key ) TO failed-yeld_cds_travel.

              APPEND VALUE #( %cid = <fs_entity_01>-%cid
                              %key = <fs_entity_01>-%key
                              %msg = exc_01 ) TO reported-yeld_cds_travel.
            ENDLOOP.

        ENDTRY.
      CATCH cx_nr_object_not_found INTO DATA(exc_02).
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity_02>).
          APPEND VALUE #( %cid = <fs_entity_02>-%cid
                          %key = <fs_entity_02>-%key ) TO failed-yeld_cds_travel.

          APPEND VALUE #( %cid = <fs_entity_02>-%cid
                          %key = <fs_entity_02>-%key
                          %msg = exc_02 ) TO reported-yeld_cds_travel.
        ENDLOOP.
    ENDTRY.

    lv_last_number = lv_last_number + 1.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
      APPEND VALUE #( %cid = <fs_entity>-%cid
                      TravelId = lv_last_number ) TO mapped-yeld_cds_travel.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_booking.
    DATA: lv_quantity TYPE /dmo/booking_id.

    READ ENTITIES OF yeld_cds_travel IN LOCAL MODE
        ENTITY yeld_cds_travel BY \_booking
        FROM CORRESPONDING #( entities )
        LINK DATA(lt_linked_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>) GROUP BY <entity>-TravelId.
      lv_quantity = REDUCE #( INIT lv_maximo = CONV /dmo/booking_id( '0' )
                              FOR ls_linked_data IN lt_linked_data WHERE ( source-TravelId = <entity>-TravelId )
                              NEXT lv_maximo = COND /dmo/booking_id( WHEN lv_maximo < ls_linked_data-target-bookingid THEN ls_linked_data-target-bookingid
                                                                     ELSE lv_quantity ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>) USING KEY entity WHERE TravelId = <entity>-TravelId.
        LOOP AT <fs_entity>-%target ASSIGNING FIELD-SYMBOL(<booking>).
          APPEND CORRESPONDING #( <booking> ) TO mapped-yeld_cds_booking ASSIGNING FIELD-SYMBOL(<mapp>).
          IF <mapp> IS ASSIGNED AND <mapp>-BookingId IS INITIAL.
            <mapp>-BookingId = lv_quantity + 1.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD copia.
    DATA: lt_travel  TYPE TABLE FOR CREATE yeld_cds_travel,
          lt_booking TYPE TABLE FOR CREATE yeld_cds_travel\_booking,
          lt_booksup TYPE TABLE FOR CREATE yeld_cds_booking\_bookingSup.

    READ ENTITIES OF yeld_cds_travel IN LOCAL MODE " local mode traz os registros já carregados
      ENTITY yeld_cds_travel
      ALL FIELDS WITH CORRESPONDING #( keys ) " aqui vem as chaves da entidade travel
      RESULT DATA(lt_travel_res)
      FAILED DATA(lt_travel_fail).

    READ ENTITIES OF yeld_cds_travel IN LOCAL MODE
      ENTITY yeld_cds_travel BY \_booking
      ALL FIELDS WITH CORRESPONDING #( lt_travel_res ) " aqui foi carregado o registro travel, na tabela interna
      RESULT DATA(lt_booking_res)
      FAILED DATA(lt_booking_fail).

    READ ENTITIES OF yeld_cds_travel IN LOCAL MODE
      ENTITY yeld_cds_booking BY \_bookingSup
      ALL FIELDS WITH CORRESPONDING #( lt_booking_res )
      RESULT DATA(lt_bookingSup_res)
      FAILED DATA(lt_bookingSup_fail).


    LOOP AT lt_travel_res ASSIGNING FIELD-SYMBOL(<travel>).
      " monta a estrutura da tabela de criação, com os dados copiados
      APPEND VALUE #( %cid  = keys[ TravelId = <travel>-TravelId ]-%cid
                      %data = CORRESPONDING #( <travel> EXCEPT TravelId ) ) TO lt_travel ASSIGNING FIELD-SYMBOL(<travel_create>).

      " tem que ser numerado novamente, caso não seja informado o TravelId no except
      CLEAR <travel>-TravelId.

      "faz a ligação dos dados da travel, com o booking
      APPEND VALUE #( %cid_ref = <travel_create>-%cid ) TO lt_booking ASSIGNING FIELD-SYMBOL(<booking_create>).

      " percorre os booking, do travel correspondente
      LOOP AT lt_booking_res ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE TravelId = <travel>-TravelId.
        APPEND VALUE #( %cid  = <travel>-TravelId && <booking>-BookingId
                        %data = CORRESPONDING #( <booking> EXCEPT TravelId ) ) TO <booking_create>-%target ASSIGNING FIELD-SYMBOL(<booking_create_loop>).

        APPEND VALUE #( %cid_ref = <booking_create_loop>-%cid ) TO lt_booksup ASSIGNING FIELD-SYMBOL(<booking_sup_create>).

        LOOP AT lt_bookingSup_res ASSIGNING FIELD-SYMBOL(<bookingSup>) USING KEY entity WHERE TravelId  = <travel>-TravelId AND
                                                                                              BookingId = <booking>-BookingId.
          APPEND VALUE #( %cid  = <travel>-TravelId && <booking>-BookingId && <bookingSup>-BookingSupplementId
                          %data = CORRESPONDING #( <bookingSup> EXCEPT TravelId BookingId ) ) TO <booking_sup_create>-%target ASSIGNING FIELD-SYMBOL(<booking_sup_create_loop>).
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    " insert dos dados
    MODIFY ENTITIES OF yeld_cds_travel IN LOCAL MODE
      ENTITY yeld_cds_travel
        CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
        WITH lt_travel
      ENTITY yeld_cds_travel
        CREATE BY \_booking FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
        WITH lt_booking
      ENTITY yeld_cds_booking
        CREATE BY \_bookingSup FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
        WITH lt_booksup
      MAPPED DATA(it_mapp).

      mapped-yeld_cds_travel = it_mapp-yeld_cds_travel.

  ENDMETHOD.

ENDCLASS.
