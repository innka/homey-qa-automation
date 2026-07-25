# ==========================================
# FILE: voyageur_annule_reservation.robot
# Tests fonctionnels - PP-36 / PP-37 / PP-38 : annuler une réservation et vérifier le statut ANNULÉ côté Voyageur et côté Hôte
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Teardown   Fermer l'application8

*** Variables ***
${STATUT RESERVATION AVANT ANNULATION}    DISPONIBLE
${STATUT RESERVATION APRES ANNULATION}    ANNULÉ
${RAISON ANNULATION}                      Je ne peux plus venir

${USER MENU}                              css=.account-loggedin
${BUTTON VOYAGES}                         xpath=//div[contains(@class,'account-dropdown')]//a[contains(normalize-space(.),'Voyages')]
${BUTTON ANNULER}                         xpath=(//button[@id='cancel-reservation-btn'])[2]

*** Keywords ***
Se connecter comme voyageur
    Ouvrir le navigateur et accéder à l'application
    Se connecter    ${UTILISATEUR VALIDE}    ${MOT DE PASSE VALIDE}

Aller dans Voyages
    Press Keys    NONE     HOME
    Wait Until Element Is Visible    ${USER MENU}    15s
    #Wait Until Keyword Succeeds    3x    1s    Ouvrir le menu Voyages
    Go To    ${URL}index.php/reservations/
    Wait Until Page Contains Element    xpath=//tbody/tr    15s

Annuler la réservation
    Wait Until Element Is Visible    ${BUTTON ANNULER}    10s
    Click Element    ${BUTTON ANNULER}

    # Confirmer l'annulation avec un motif
    Wait Until Element Is Visible    xpath=//textarea[@id='reason']    10s
    Input Text    xpath=//textarea[@id='reason']    ${RAISON ANNULATION}
    Click Button    xpath=//button[@id='cancelled']

Se deconnecter depuis Voyages
    ${logout_url}=    Get Element Attribute
    ...    xpath=//div[contains(@class,'account-dropdown')]//a[contains(@href,'action=logout')]    href
    Go To    ${logout_url}
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    10s

*** Test Cases ***
Tester annuler une réservation et vérifier le statut ANNULÉ des deux côtés
    [Documentation]    PP-36 / PP-37 / PP-38 - Le voyageur annule une réservation DISPONIBLE. Le statut devient ANNULÉ côté voyageur et côté hôte.
    [Tags]    US-08    PP-36    PP-37    PP-38

    # PP-36 : Annuler une réservation
    Se connecter comme voyageur
    Aller dans Voyages
    Ouvrir une réservation avec le statut    ${STATUT RESERVATION AVANT ANNULATION}

    # Mémoriser l'ID pour les vérifications suivantes
    ${reservation_id}=    Récupérer l'ID de la réservation
    Log    Réservation à annuler : ${reservation_id}
    Run Keyword And Continue On Failure    Annuler la réservation
    Log    ===== Fin de la vérification PP-36 =====

    # PP-37 : Vérifier le statut côté voyageur
    Aller dans Voyages
    Run Keyword And Continue On Failure    
    ...    Vérifier le statut d'une réservation    ${reservation_id}    ${STATUT RESERVATION APRES ANNULATION}
    Log    ===== Fin de la vérification PP-37 =====

    # PP-38 : Vérifier le statut côté hôte
    Se deconnecter depuis Voyages
    Se connecter    ${HOTE_EMAIL}    ${HOTE_PASSWORD}

    Click Element    ${BUTTON RESERVATIONS}
    Run Keyword And Continue On Failure
    ...    Vérifier le statut d'une réservation    ${reservation_id}    ${STATUT RESERVATION APRES ANNULATION}
    Log    ===== Fin de la vérification PP-38 =====