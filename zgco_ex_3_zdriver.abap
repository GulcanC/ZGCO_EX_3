*&---------------------------------------------------------------------*
*& Report ZGCO_EX_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgco_ex_3.


"INCLUDE ZGCO_EX_3_top. "Déclaration de mes variables globales, global variable declaration
"INCLUDE ZGCO_EX_3_scr. "Déclaration de notre écran de sélection, declaration of the selection screen
INCLUDE ZGCO_EX_3_f01. "Traitements effectués sur les données, data processing



START-OF-SELECTION.

* PERFORM select_data_general.
* PERFORM append_insert.
PERFORM full_example.