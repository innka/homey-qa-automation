# ==========================================
# FILE: blocage_dates.robot
# Tests fonctionnels - PP-17 : vérifier le blocage des dates réservées
# ==========================================

*** Settings ***
Resource        commun_US-07.resource
Test Setup      Préparer le test
Test Teardown   Fermer l'application

*** Variables ***
${CHAMP DATE FIN}                   css=input[name="depart"]
${MESSAGE DATES INDISPONIBLES}      Vos dates ne sont pas disponibles
${ERREUR DATES}                     css=.block-body-sidebar > .notify

*** Keywords ***
Réserver l'annonce
    # Réserver des dates disponibles
    Choisir des dates disponibles aléatoires

    ${date_debut_reserve}=    Get Value    ${CHAMP DATE DEBUT}
    ${date_fin_reserve}=      Get Value    ${CHAMP DATE FIN}

    Choisir le nombre de voyageurs

    Click Button    ${BUTTON DEMANDE RESERVATION}
    Wait Until Element Is Visible    ${DEMANDE ENVOYEE}    10s

    RETURN    ${date_debut_reserve}    ${date_fin_reserve}

Convertir les dates réservées en timestamps
    [Arguments]    ${date_debut_reserve}    ${date_fin_reserve}

    # Conversion des dates en timestamps pour le calendrier
    ${timestamp_debut}=    Evaluate
    ...    int(datetime.datetime.strptime($date_debut_reserve, "%Y-%m-%d").replace(tzinfo=datetime.timezone.utc).timestamp())
    ...    modules=datetime

    ${timestamp_fin}=    Evaluate
    ...    int(datetime.datetime.strptime($date_fin_reserve, "%Y-%m-%d").replace(tzinfo=datetime.timezone.utc).timestamp())
    ...    modules=datetime

    RETURN    ${timestamp_debut}    ${timestamp_fin}

Vérifier le message pour les dates déjà réservées
    [Arguments]    ${date_debut_reserve}    ${date_fin_reserve}

    # Recharger la page pour simuler une nouvelle réservation
    Reload Page
    Wait Until Element Is Visible    ${CHAMP DATE DEBUT}    10s

    # Convertir les dates réservées en timestamps
    ${timestamp_debut}    ${timestamp_fin}=
    ...    Convertir les dates réservées en timestamps
    ...    ${date_debut_reserve}
    ...    ${date_fin_reserve}

    # Ouvrir le calendrier
    Click Element    ${CHAMP DATE DEBUT}
    Wait Until Element Is Visible    ${CALENDRIER}    10s

    # Localiser les dates uniquement dans le mois visible
    ${date_debut_locator}=    Set Variable
    ...    xpath=//div[@id='single-booking-search-calendar']//div[contains(@class,'single-listing-calendar-wrap') and not(contains(@style,'display: none'))]//li[@data-timestamp='${timestamp_debut}']

    ${date_fin_locator}=    Set Variable
    ...    xpath=//div[@id='single-booking-search-calendar']//div[contains(@class,'single-listing-calendar-wrap') and not(contains(@style,'display: none'))]//li[@data-timestamp='${timestamp_fin}']

    # Vérifier si les dates sont affichées dans le mois actuel
    ${date_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${date_debut_locator}

    # Passer au mois suivant si nécessaire
    IF    not ${date_visible}
        Click Button    ${BUTTON NEXT MONTH}
        Wait Until Element Is Visible    ${date_debut_locator}    10s
    END

    # Sélectionner les mêmes dates déjà réservées
    Wait Until Element Is Visible    ${date_debut_locator}    10s
    Click Element    ${date_debut_locator}

    Wait Until Element Is Visible    ${date_fin_locator}    10s
    Click Element    ${date_fin_locator}

    # Choisir le nombre de voyageurs
    Choisir le nombre de voyageurs

    # Envoyer une nouvelle demande avec les mêmes dates
    Click Button    ${BUTTON DEMANDE RESERVATION}

    # Vérifier le message d'indisponibilité
    Wait Until Element Is Visible    ${ERREUR DATES}    10s
    Element Should Contain    ${ERREUR DATES}    ${MESSAGE DATES INDISPONIBLES}
    
Vérifier que les dates réservées ne sont plus sélectionnables
    [Arguments]    ${date_debut_reserve}    ${date_fin_reserve}

    Reload Page

    ${timestamp_debut}    ${timestamp_fin}=    Convertir les dates réservées en timestamps    ${date_debut_reserve}    ${date_fin_reserve}

    Click Element    ${CHAMP DATE DEBUT}
    Wait Until Element Is Visible    ${CALENDRIER}    10s

    # Vérifier que la date de début est bloquée
    Page Should Not Contain Element
...    xpath=//div[@id='single-booking-search-calendar']//li[@data-timestamp='${timestamp_debut}' and contains(@class,'day-available')]
...    La date de début réservée ${date_debut_reserve} est toujours disponible.

    # Vérifier que la date de fin est bloquée
    Page Should Not Contain Element
...    xpath=//div[@id='single-booking-search-calendar']//li[@data-timestamp='${timestamp_fin}' and contains(@class,'day-available')]
...    La date de fin réservée ${date_fin_reserve} est toujours disponible.

*** Test Cases ***
Tester le message pour des dates déjà réservées
    [Documentation]    Vérifier qu'un message d'erreur est affiché lorsqu'une nouvelle réservation est tentée avec des dates déjà réservées.
    [Tags]    US-07

    ${date_debut_reserve}    ${date_fin_reserve}=    Réserver l'annonce

    Vérifier le message pour les dates déjà réservées    ${date_debut_reserve}    ${date_fin_reserve}
    Log    ===== Fin de la vérification PP-17 =====

# Tester le blocage des dates réservées
#     [Documentation]    Vérifier que les dates de début et de fin déjà réservées deviennent indisponibles et ne peuvent plus être sélectionnées.
#     [Tags]    US-07    Régression    Bug-PP-21

#     ${date_debut_reserve}    ${date_fin_reserve}=    Réserver l'annonce
#     Vérifier que les dates réservées ne sont plus sélectionnables    ${date_debut_reserve}    ${date_fin_reserve}