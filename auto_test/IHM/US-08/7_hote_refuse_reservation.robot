# ==========================================
# FILE: hote_refuse_reservation.robot
# Tests fonctionnels - PP-27 / PP-28 / PP-29 : refuser une réservation avec justification et vérifier le statut côté hôte et voyageur
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Setup      Préparer le test8
Test Teardown   Fermer l'application8

*** Variables ***
${BUTTON REFUSER}         xpath=(//button[@id='decline-reservation-btn'])[2]
${INPUT JUSTIFICATION}    xpath=//textarea[@id='reason22']
${BUTTON SOUMETTRE}       xpath=//button[@id='decline']
${MESSAGE REFUS}          Logement indisponible
${STATUT RESERVATION}     css=.btn-danger-outlined:nth-child(2)

${ID_RESERVATION}         ${EMPTY}

*** Keywords ***
Refuser la réservation avec une justification
    Ouvrir une réservation avec le statut    NOUVEAU
    # Mémoriser l'ID pour les vérifications suivantes
    ${reservation_id}=    Récupérer l'ID de la réservation
    Set Suite Variable    ${ID_RESERVATION}    ${reservation_id}

    Click Button    ${BUTTON REFUSER}
    Wait Until Element Is Visible    ${INPUT JUSTIFICATION}    10s

    # Saisir le motif du refus
    Input Text    ${INPUT JUSTIFICATION}    ${MESSAGE REFUS}
    Click Button    ${BUTTON SOUMETTRE}

    # Vérifier le changement de statut
    Wait Until Element Is Visible    ${STATUT RESERVATION}    10s
    Element Should Contain    ${STATUT RESERVATION}    Refusé
    RETURN    ${reservation_id}

*** Test Cases ***
Tester le refus d'une réservation avec justification et les statuts des deux côtés
    [Documentation]    L'hôte peut refuser une réservation avec une justification et le statut est correctement mis à jour pour l'hôte et le voyageur.
    [Tags]    US-08    PP-27    PP-28    PP-29

    # PP-27 : Refuser une réservation
    Refuser la réservation avec une justification
    Log    ===== Fin de la vérification PP-27 =====

    # PP-28 : Vérifier le statut côté hôte
    Retourner au tableau réservations Hôte
    Run Keyword And Continue On Failure    Vérifier le statut d'une réservation    ${ID_RESERVATION}    REFUSÉ
    Log    ===== Fin de la vérification PP-28 =====

    # PP-29 : Vérifier le statut côté voyageur
    Se deconnecter
    Se connecter    ${UTILISATEUR VALIDE}    ${MOT DE PASSE VALIDE}
    Run Keyword And Continue On Failure    Vérifier le statut d'une réservation    ${ID_RESERVATION}    REFUSÉ
    Log    ===== Fin de la vérification PP-29 =====
