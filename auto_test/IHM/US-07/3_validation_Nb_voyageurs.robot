# ==========================================
# FILE: validation_Nb_voyageurs.robot
# Tests fonctionnels - PP-18 : vérifier la validation du nombre de voyageurs
# ==========================================

*** Settings ***
Resource        commun_US-07.resource
Test Setup      Préparer le test
Test Teardown   Fermer l'application

*** Variables ***
${ERREUR}             css=.block-body-sidebar > .notify
${MESSAGE ERREUR}     Veuillez choisir des voyageurs

*** Keywords ***
Oublier de choisir le nombre de voyageurs
    [Documentation]    Ne pas sélectionner de nombre de voyageurs pour tester la validation
    Click Element    ${CHAMP VOYAGEURS}
    Wait Until Element Is Visible    ${BUTTON AJOUTER ADULTE}    10s
    Click Button    css=.sidebar-booking-module-body:nth-child(2) .guest-apply-btn > .btn
    Click Button    ${BUTTON DEMANDE RESERVATION}
    Wait Until Element Is Visible    ${DEMANDE ENVOYEE}    10s

*** Test Cases ***
Tester la validation du nombre de voyageurs
    [Documentation]    Vérifier qu'une réservation est bloquée si aucun nombre de voyageurs n'est sélectionné.
    [Tags]    US-07    PP-18

    Choisir des dates disponibles aléatoires
    Oublier de choisir le nombre de voyageurs
