FORM select_data_general .
    *&---------------------------------------------------------------------*
    *& Form select_data_general
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    
    
    ************************************* ZDRIVER_CAR_KDE ****************************************************
    
    ********************************** EXAMPLE 1 ********************************************
    
    
    * 1) Combiene de lignes comptent actuellement notre table ?
    * 1) How many rows does our table currently have ?
    
    * First way
    
      DATA : lv_rows TYPE i.
    
      SELECT COUNT(*) FROM zdriver_car_kde INTO @lv_rows.
    
      cl_demo_output=>display( lv_rows ).
    
    * Second way
    
      SELECT COUNT(*) FROM zdriver_car_kde INTO @DATA(lv_rows1).
    
      cl_demo_output=>display( lv_rows1 ).
    
    ********************************** EXAMPLE 2 ********************************************
    
    * Combien de voiture grise, rouge and vert dans cette table ?
    * Are there how many grey, red and green cars in the table ?
    
    * First way
    
      SELECT COUNT(*) FROM zdriver_car_kde INTO @DATA(lv_car_grise) WHERE car_color ='GRISE'.
    
      cl_demo_output=>display( lv_car_grise ).
    
    * Second way
    
      DATA :lv_car_grise_1 TYPE i.
    
      SELECT * FROM zdriver_car_kde INTO @DATA(lv_zdriver_1).
    
        IF lv_zdriver_1-car_color = 'GRISE'.
          lv_car_grise_1 = lv_car_grise_1 + 1.
        ENDIF.
      ENDSELECT.
    
      cl_demo_output=>display( lv_car_grise_1 ).
    
    * Third way
    
    
      DATA :lt_zdriver_car TYPE TABLE OF zdriver_car_kde,
            lv_car_vert    TYPE i.
    
      SELECT * FROM zdriver_car_kde INTO TABLE lt_zdriver_car.
    
      IF sy-subrc = 0.
        LOOP AT lt_zdriver_car ASSIGNING FIELD-SYMBOL(<fs_car_vert>).
          IF <fs_car_vert>-car_color = 'VERT'.
            lv_car_vert = lv_car_vert + 1.
          ENDIF.
        ENDLOOP.
      ENDIF.
    
      cl_demo_output=>display( lv_car_vert ).
    
    ********************************** EXAMPLE 3 ********************************************
    
    * selectionner l'année de la fabrication de la voiture la plus recent.
    * select the most recent car year
    
    * First way
    
      SELECT SINGLE MAX( car_year ) FROM zdriver_car_kde
        INTO @DATA(lv_car_year).
    
      cl_demo_output=>display( lv_car_year ).
    
    * Second way, here the min date is 0 because a row is empty, so it accepts as 0.
    * But you can see in the table mara, MIN works also like MAX
    
      SELECT SINGLE MIN( car_year ) FROM zdriver_car_kde
        INTO @DATA(lv_car_year_min).
    
      cl_demo_output=>display( lv_car_year_min ).
    
    * Second way
    
      SELECT MIN( ersda ) FROM mara
        INTO @DATA(lv_date).
    
      cl_demo_output=>display( lv_date ).
    
    *********************************************** EXAMPLE 4 ****************************************
    
    * recuperer le propritaire de cette voiture
    * get the name of the owner of this car
    
      SELECT SINGLE name, surname, car_year FROM zdriver_car_kde
        INTO @DATA(lv_car_owner)
        WHERE car_year = @lv_car_year.
    
      cl_demo_output=>display( lv_car_owner ).
    
    *********************************************** EXAMPLE 4 ****************************************
    
    * verifier à l'aide d'une lecture directe s'il existe une voiture de la marque "KIA"  dans notre table
    * verify that whether a car with type "kia' exist in the table.
    
      DATA : lv_number_kia TYPE i.
      SELECT * FROM zdriver_car_kde INTO @DATA(lv_car_brand_kia).
    
        IF lv_car_brand_kia-car_brand = 'KIA'.
          lv_number_kia = lv_number_kia + 1.
          WRITE : / 'The number of car KIA is ' && ' ' && lv_number_kia.
        ENDIF.
    
      ENDSELECT.
    
    *********************************************** EXAMPLE 5 ****************************************
    
    * Vérifiez à l'aide d'une lecture directe s'il existe une voiture de la marque "KIA"
    * It is the same example with the above, verify that the the car brand "KIA" exist or not in the table.
    * when you use "TRANSPORTING NO FIELD", the statement "READ TABLE" only checks whether the row is being searched for exists
    * and fills the system field sy-subrc
    * the system can not access the content of the found row.
    * burada sana sayiyi vermiyor sadece bulup bulamadigini soyluyor.
    
    
      SELECT * FROM zdriver_car_kde INTO TABLE @DATA(lt_zdriver5).
    
      READ TABLE lt_zdriver5 TRANSPORTING NO FIELDS WITH KEY car_brand = 'KIA'.
    
      IF sy-subrc = 0.
        MESSAGE i009(zgco_msg).
      ELSE.
        MESSAGE i010(zgco_msg).
      ENDIF.
    
    *********************************************** EXAMPLE 6 ****************************************
    
    * Creer une autre table interne au meme format que votre premiere table puis effectuez
    * une lecture séquentielle sur notre premiere table et ajoutez dans notre deuxime table
    * uniquement les lignes de la premiere table pour lesquelles le proprietaire vit à Toulouse,
    * et affichez le deuxime table.
    
    * First way
    
      DATA : ls_zdriver6 TYPE zdriver_car_kde,
             lt_zdriver7 TYPE SORTED TABLE OF zdriver_car_kde WITH NON-UNIQUE KEY  id_driver.
    
      SELECT * FROM zdriver_car_kde INTO TABLE @DATA(lt_zdriver6).
    
      LOOP AT lt_zdriver6 ASSIGNING FIELD-SYMBOL(<fs_driver6>) WHERE city = 'TOULOUSE' OR city = 'Toulouse'.
        MOVE <fs_driver6> TO ls_zdriver6.
        APPEND ls_zdriver6 TO lt_zdriver7.
      ENDLOOP.
    
      cl_demo_output=>display( lt_zdriver7 ).
    
      cl_demo_output=>display( ls_zdriver6 ).
    
    * Second way, if city is Arras
    
      DATA : lt_zdriver_car1 TYPE TABLE OF zdriver_car_kde,
             lt_zdriver_car2 TYPE TABLE OF zdriver_car_kde,
             ls_zdriver_car  TYPE  zdriver_car_kde.
    
      SELECT * FROM zdriver_car_kde INTO TABLE lt_zdriver_car1.
    
      LOOP AT lt_zdriver_car1 ASSIGNING FIELD-SYMBOL(<fs_zdriver_car>).
        IF <fs_zdriver_car>-city = 'ARRAS' OR <fs_zdriver_car>-city = 'Arras'.
          MOVE <fs_zdriver_car> TO ls_zdriver_car.
          APPEND ls_zdriver_car TO lt_zdriver_car2.
        ENDIF.
      ENDLOOP.
    
      cl_demo_output=>display( lt_zdriver_car2 ).
    
    * Third way, if the car brand is citroen
    
      DATA : lt_zdriver_car_kde2 TYPE TABLE OF zdriver_car_kde,
             ls_zdriver_car_kde2 TYPE  zdriver_car_kde.
    
      SELECT * FROM zdriver_car_kde INTO TABLE @DATA(lt_zdriver_car_kde1).
    
      LOOP AT lt_zdriver_car_kde1 ASSIGNING FIELD-SYMBOL(<fs_zdriver_car_kde1>).
        CHECK <fs_zdriver_car_kde1>-car_brand = 'FERRARI' OR <fs_zdriver_car_kde1>-car_brand = 'CITROEN'.
        MOVE <fs_zdriver_car_kde1> TO ls_zdriver_car_kde2.
        APPEND ls_zdriver_car_kde2 TO lt_zdriver_car_kde2.
      ENDLOOP.
    
      cl_demo_output=>display( lt_zdriver_car_kde2 ).
    
    *********************************************** EXAMPLE 7 ****************************************
    
    * videz la deuxieme table (lt_zdriver_car_kde2), renouvellez la meme opération.
    * cette fois ne transferez dans le deuxieme table que la ligne correspondant à la premiere voiture grise
    * In this case, the result will show me only first grey car.
    
    * First declare internal tables (first and second internal tables) and structure
      DATA : lt_zdriver_car3 TYPE TABLE OF zdriver_car_kde,
             lt_zdriver_car4 TYPE TABLE OF zdriver_car_kde,
             ls_zdriver_car3 TYPE  zdriver_car_kde.
    
    * select data from table
      SELECT * FROM zdriver_car_kde INTO TABLE lt_zdriver_car3.
    
    * loop at to display all the grey cars
      LOOP AT lt_zdriver_car3 ASSIGNING FIELD-SYMBOL(<fs_zdriver_car3>).
        IF <fs_zdriver_car3>-car_color = 'GRISE' .
          MOVE <fs_zdriver_car3> TO ls_zdriver_car3.
          APPEND ls_zdriver_car3 TO lt_zdriver_car4.
        ENDIF.
      ENDLOOP.
    
    * display all the grey cars
      cl_demo_output=>display( lt_zdriver_car4 ).
    
    
    * NOW display first grey car, FIRST WAY
    
    * clear second table
    
      CLEAR lt_zdriver_car4.
    
    * Loop at to see just first grey car
      LOOP AT lt_zdriver_car3 ASSIGNING <fs_zdriver_car3>.
        CHECK <fs_zdriver_car3>-car_color = 'GRISE'.
        <fs_zdriver_car3> = ls_zdriver_car3.
      ENDLOOP.
    
      cl_demo_output=>display( ls_zdriver_car3 ).
    
    
    * NOW display first grey car, SECOND WAY
    
    
      CLEAR lt_zdriver_car4.
    
      LOOP AT lt_zdriver_car3 ASSIGNING <fs_zdriver_car3>.
        CHECK <fs_zdriver_car3>-car_color = 'GRISE'.
        MOVE <fs_zdriver_car3> TO ls_zdriver_car3.
        EXIT.
      ENDLOOP.
    
      cl_demo_output=>display( ls_zdriver_car3 ).
    
    
    * NOW display first grey car, THIRD WAY
    
      CLEAR lt_zdriver_car4.
    
      LOOP AT lt_zdriver_car4 ASSIGNING <fs_zdriver_car3> WHERE car_color = 'GRISE'.
        <fs_zdriver_car3> = ls_zdriver_car3.
      ENDLOOP.
    
      cl_demo_output=>display( ls_zdriver_car3 ).
    
    * NOW display first grey car, FOURTH WAY
    
      CLEAR lt_zdriver_car4.
    
      LOOP AT lt_zdriver_car3 ASSIGNING  <fs_zdriver_car3> WHERE car_color = 'GRISE'.
        MOVE <fs_zdriver_car3> TO ls_zdriver_car3.
        APPEND ls_zdriver_car3 TO lt_zdriver_car4.
        EXIT.
    
      ENDLOOP.
    
      cl_demo_output=>display( ls_zdriver_car3 ).
    
    * NOW display first grey car, FIFTH WAY
    
      CLEAR lt_zdriver_car4.
    
      LOOP AT lt_zdriver_car3 ASSIGNING <fs_zdriver_car3> WHERE car_color = 'GRISE'.
        IF sy-subrc = 0.
          ls_zdriver_car3 = <fs_zdriver_car3>.
          APPEND ls_zdriver_car3 TO lt_zdriver_car4.
        ENDIF.
    
      ENDLOOP.
    
      cl_demo_output=>display( ls_zdriver_car3 ).
    
    
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *& Form append_insert
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    FORM append_insert .
    * APPEND a new row at the end of the table ZDRIVER_CAR_KDE
    * copy the content of the first table to the second table.
    * add a row in the 2. internal table with new information
    
    
      DATA : lt_zdriver_car_kde TYPE SORTED TABLE OF zdriver_car_kde WITH NON-UNIQUE KEY id_driver,
             ls_zdriver_car_kde TYPE zdriver_car_kde.
    
    
    
    *  ls_zdriver_car_kde-mandt = sy-mandt.
    *  ls_zdriver_car_kde-id_driver = 'MCK'.
    *  ls_zdriver_car_kde-surname = 'Micky'.
    *  ls_zdriver_car_kde-name ='Mouse'.
    *  ls_zdriver_car_kde-date_birth = '20001010'.
    *  ls_zdriver_car_kde-city = 'Chicago'.
    *  ls_zdriver_car_kde-region = 'Illinois'.
    *  ls_zdriver_car_kde-country = 'USA'.
    *  ls_zdriver_car_kde-car_brand = 'TESLA'.
    *  ls_zdriver_car_kde-car_model = 'Model Y'.
    *  ls_zdriver_car_kde-car_year ='2023'.
    *  ls_zdriver_car_kde-car_color ='Blue'.
    *  ls_zdriver_car_kde-car_id = ''.
    *  ls_zdriver_car_kde-lang = 'F'.
    
    *  ls_zdriver_car_kde-mandt = sy-mandt.
    *  ls_zdriver_car_kde-id_driver = 'GCO'.
    *  ls_zdriver_car_kde-surname = 'COSKUN'.
    *  ls_zdriver_car_kde-name = 'Gulcan'.
    *  ls_zdriver_car_kde-date_birth = '19840915'.
    *  ls_zdriver_car_kde-city = 'Ankara'.
    *  ls_zdriver_car_kde-region = 'IA'.
    *  ls_zdriver_car_kde-country = 'TR'.
    *  ls_zdriver_car_kde-car_brand = 'Wolswogen'.
    *  ls_zdriver_car_kde-car_model = 'Polo'.
    *  ls_zdriver_car_kde-car_year = 2009.
    *  ls_zdriver_car_kde-car_color = 'Brown'.
    *  ls_zdriver_car_kde-car_id = 'XX266XX'.
    *  ls_zdriver_car_kde-lang = 'TR'.
    
      ls_zdriver_car_kde-mandt = sy-mandt.
      ls_zdriver_car_kde-id_driver = 'GGG'.
      ls_zdriver_car_kde-surname = 'COSKUN'.
      ls_zdriver_car_kde-name = 'Gulcan'.
      ls_zdriver_car_kde-date_birth = '19840915'.
      ls_zdriver_car_kde-city = 'Ankara'.
      ls_zdriver_car_kde-region = 'IAB'.
      ls_zdriver_car_kde-country = 'TR'.
      ls_zdriver_car_kde-car_brand = 'Wolswogen'.
      ls_zdriver_car_kde-car_model = 'Polo'.
      ls_zdriver_car_kde-car_year = 2009.
      ls_zdriver_car_kde-car_color = 'Brown'.
      ls_zdriver_car_kde-car_id = 'XX266XX'.
      ls_zdriver_car_kde-lang = 'TR'.
    
    * With Append we add the new row to the internal table lt_zdriver_car_kde
    * Our new row was not added yet to the table ZDRIVER_CAR_KDE, to do that we have to use INSERT statement
    
      APPEND ls_zdriver_car_kde TO lt_zdriver_car_kde.
      cl_demo_output=>display( lt_zdriver_car_kde ).
    
    * Now insert our internal table to the data base table ZDRIVER_CAR_KDE
      INSERT zdriver_car_kde  FROM TABLE lt_zdriver_car_kde ACCEPTING DUPLICATE KEYS.
    
    * NOT : here there is a mistake if you execute the program second time. because it does not allow the same value.
    * To add the same value we use ACCEPTING DUPLICATE KEYS
    
    
    ENDFORM.
    
    *&---------------------------------------------------------------------*
    *& Form full_example
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    FORM full_example .
    
      DATA : lt_zdriver TYPE SORTED TABLE OF zdriver_car_kde WITH NON-UNIQUE KEY id_driver,
             ls_zdriver TYPE zdriver_car_kde.
    
    
    
      ls_zdriver-mandt = sy-mandt.
      ls_zdriver-id_driver = 'BB'.
      ls_zdriver-surname = 'BUNNY'.
      ls_zdriver-name = 'BUGS'.
      ls_zdriver-date_birth = '19560525'.
      ls_zdriver-city = 'NEW JERSY'.
      ls_zdriver-region = 'DEW'.
      ls_zdriver-country = 'USA'.
      ls_zdriver-car_brand = 'BMW'.
      ls_zdriver-car_model = 'TT'.
      ls_zdriver-car_year = 2023.
      ls_zdriver-car_color = 'RED'.
      ls_zdriver-car_id = 'AAAAAAAA'.
      ls_zdriver-lang = 'EN'.
    
      APPEND ls_zdriver TO lt_zdriver.
      INSERT zdriver_car_kde FROM TABLE lt_zdriver ACCEPTING DUPLICATE KEYS..
    
      cl_demo_output=>display( lt_zdriver ).
    
    
    ENDFORM.