# ==========================================
# FILE: validation_date_fin.robot
# Tests fonctionnels - PP-14 : vérifier la validation des dates de fin de réservation
# ==========================================

*** Settings ***
Resource        commun_US-07.resource
Test Setup      Préparer le test
Test Teardown   Fermer l'application

*** Variables ***
${ERREUR}             css=.block-body-sidebar > .notify
${MESSAGE ERREUR}     La date de départ doit être supérieure à la date d'arrivée

*** Keywords ***
Vérifier une date de fin invalide
    [Arguments]    ${type}

    Click Element    ${CHAMP DATE DEBUT}
    Wait Until Element Is Visible    ${CALENDRIER}    10s

    # Récupérer les dates futures disponibles
    ${timestamps}=    Execute JavaScript
    ...    return Array.from(document.querySelectorAll('#single-booking-search-calendar .single-listing-calendar-wrap:not([style*="display:none"]) li.day-available.future-day')).map(el => Number(el.dataset.timestamp));

    # Créer les périodes de deux jours consécutifs
    ${paires}=    Evaluate    [(date, date + 86400) for date in $timestamps if date + 86400 in $timestamps]

    ${nombre_paires}=    Get Length    ${paires}
    Should Be True    ${nombre_paires} > 0    Aucune période de deux jours consécutifs disponible.

    # Sélectionner une période disponible aléatoire
    ${paire}=    Evaluate    random.choice($paires)    modules=random

    # Définir les dates selon le scénario invalide
    IF    '${type}' == 'egale'
        ${date_debut}=    Set Variable    ${paire}[0]
        ${date_fin}=      Set Variable    ${paire}[0]
    ELSE IF    '${type}' == 'inferieure'
        ${date_debut}=    Set Variable    ${paire}[1]
        ${date_fin}=      Set Variable    ${paire}[0]
    ELSE
        Fail    Type de scénario inconnu : ${type}
    END

    # Tenter de sélectionner les dates invalides
    Click Element    xpath=//div[@id='single-booking-search-calendar']//li[@data-timestamp='${date_debut}' and contains(@class,'day-available')]
    Click Element    xpath=//div[@id='single-booking-search-calendar']//li[@data-timestamp='${date_fin}' and contains(@class,'day-available')]

    # Vérifier le message de validation
    Wait Until Element Is Visible    ${ERREUR}    10s
    Element Should Contain    ${ERREUR}    ${MESSAGE ERREUR}

*** Test Cases ***
Tester la date de fin égale à la date de début
    [Documentation]    Vérifier qu'il est impossible de sélectionner une date de fin égale ou antérieure à la date de début.
    [Tags]    US-07    PP-14

    Vérifier une date de fin invalide    egale
    Sleep    1s
    Vérifier une date de fin invalide    inferieure

