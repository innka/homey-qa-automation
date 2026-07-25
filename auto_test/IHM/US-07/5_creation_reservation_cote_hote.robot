# ==========================================
# FILE: creation_reservation_cote_hote.robot
# Tests fonctionnels - PP-16 : vérifier la création d'une réservation côté hôte
# ==========================================

*** Settings ***
Resource        commun_US-07.resource
Test Setup      Préparer le test
Test Teardown   Fermer l'application

*** Variables ***
${HOTE_EMAIL}                    Sera
${HOTE_PASSWORD}                 robot1

${USER MENU}                     css=.account-loggedin
${USER AVATAR}                   css=.account-loggedin .user-image

${BUTTON VOYAGES}                xpath=//div[contains(@class,'account-dropdown')]//a[contains(normalize-space(.),'Voyages')]
${BUTTON SE DECONNECTER}         xpath=//ul[contains(@class,'board-panel-menu')]//a[contains(.,'Se déconnecter')]
${BUTTON RESERVATIONS}           xpath=(//a[contains(text(),'Réservations')])[3]

${ID_RESERVATION}                ${EMPTY}

*** Keywords ***
Envoyer une demande de réservation
    # Créer une nouvelle réservation
    Choisir des dates disponibles aléatoires
    Choisir le nombre de voyageurs
    Click Button    ${BUTTON DEMANDE RESERVATION}

    Retourner à la page de Voyages

    # Mémoriser l'ID pour la vérification côté hôte
    ${ID_RESERVATION}=    Récupérer l'ID de la réservation
    Set Suite Variable    ${ID_RESERVATION}
    Log    Réservation créée avec l'ID : ${ID_RESERVATION}

Ouvrir le menu Voyages
    Mouse Over    ${USER MENU}
    Wait Until Element Is Visible    ${BUTTON VOYAGES}    3s
    Click Element    ${BUTTON VOYAGES}

Retourner à la page de Voyages
    Press Keys    None    HOME
    Wait Until Element Is Visible    ${USER MENU}    15s
    Scroll Element Into View         ${USER MENU}
    Mouse Over    ${USER MENU}
    Wait Until Keyword Succeeds    3x    1s    Ouvrir le menu Voyages
    Wait Until Location Contains    /reservations/    15s
    Ouvrir une réservation avec le statut    À L'ÉTUDE

Se connecter comme hôte
    Click Element    ${LIEN SE CONNECTER}

    Wait Until Element Is Visible    ${CHAMP NOM UTILISATEUR}    10s
    Input Text    ${CHAMP NOM UTILISATEUR}    ${HOTE_EMAIL}
    Input Text    ${CHAMP MOT DE PASSE}    ${HOTE_PASSWORD}

    Click Button    ${BOUTON VALIDER}

    Wait Until Element Is Visible    ${BUTTON ACCUEIL}    10s

Se déconnecter
    Wait Until Element Is Visible    ${BUTTON SE DECONNECTER}    10s
    Click Element    ${BUTTON SE DECONNECTER}
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    10s

Vérifier la demande côté hôte
    # Changer d'utilisateur pour vérifier la réservation
    Se déconnecter
    Se connecter comme hôte

    ${LIGNE_RESERVATION}=    Set Variable    xpath=//tbody/tr[td[@data-label='ID' and normalize-space(.)='#${ID_RESERVATION}']]

    Wait Until Element Is Visible    ${LIGNE_RESERVATION}    10s
    ${STATUT}=    Get Text    xpath=//tbody/tr[td[@data-label='ID' and normalize-space(.)='#${ID_RESERVATION}']]//td[@data-label='Statut']//span
    Should Be Equal    ${STATUT}    NOUVEAU

    # Vérifier que la réservation est bien créée avec le bon statut
    Log    La réservation #${ID_RESERVATION} est présente avec le statut ${STATUT}

*** Test Cases ***
Tester la création d'une réservation côté hôte
    [Documentation]    Vérifier qu'une demande de réservation soumise par le voyageur apparaît dans le tableau de bord de l'hôte avec le statut NOUVEAU.
    [Tags]    US-07    PP-16

    Envoyer une demande de réservation
    Vérifier la demande côté hôte  