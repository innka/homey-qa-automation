# FILE: commun.resource
# Compatible avec :
# - demande-voyageur-connecter.robot
# - demande-voyageur_non_connecter.robot 
# - validation_date_fin.robot 
# - validation_Nb_voyageurs.robot 
# - creation_reservation_cote_hote.robot 
# - blocage_dates.robot 

*** Settings ***
Library           SeleniumLibrary
Resource          ../US-08/commun_US-08.resource

*** Variables ***
# ------------------------------------------
# GLOBAL
# ------------------------------------------
${SERVEUR}                         livraison3.testacademy.fr
${URL}                             http://${SERVEUR}/
${NAVIGATEUR}                      Firefox
${UTILISATEUR_VOYAGEUR}            robot
${MOT_DE_PASSE_VOYAGEUR}           robot

# ------------------------------------------
# LOGIN VOYAGEUR
# ------------------------------------------
${LIEN SE CONNECTER}               xpath=//a[contains(text(),'Se connecter')]
${CHAMP NOM UTILISATEUR}           name=username
${CHAMP MOT DE PASSE}              name=password
${BOUTON VALIDER}                  css=.homey_login_button

${UTILISATEUR VALIDE}              robot
${MOT DE PASSE VALIDE}             robot
${MODAL LOGIN}                     id=modal-login
${TITRE TABLEAU DE BORD VOYAGEUR}  Accueil - Livraison 3

# ------------------------------------------
# PAGE D'ACCUEIL
# ------------------------------------------
${BUTTON ACCUEIL}                  xpath=//li[@id='menu-item-4630']/a
${TITRE ACCUEIL}                   Réservez et découvrez des endroits exceptionnels
${BUTTON CHERCHER ANNONCE}         css=.search-button > .btn-primary:nth-child(1)

# ------------------------------------------
# CHERCHER UNE ANNONCE
# ------------------------------------------
${DESTINATION}     Miami 
${BAR DESTINATION}     xpath=//span[contains(.,'Destination')] 
${TEXT CHAMP DESTINATION}     css=.open > .dropdown-menu .form-control 
${BUTTON CHERCHER}     xpath=(//button[@type='button'])[12] 
   
${ANNONCE}     xpath=(//div[contains(@class,'half-map-left-wrap')]//a[contains(@href,'/listing/hub-haymarket/')])
# ------------------------------------------
# RÉSERVATION
# ------------------------------------------
${CHAMP DATE DEBUT}                css=input[name="arrive"]
${CALENDRIER}                      id=single-booking-search-calendar

${CHAMP VOYAGEURS}                 css=input[name="guests"]
${BUTTON AJOUTER ADULTE}           css=.adult_plus
${BUTTON APPLIQUER VOYAGEURS}      css=.apply_guests

${BUTTON DEMANDE RESERVATION}      id=request_for_reservation
${DEMANDE ENVOYEE}                 css=.block-body-sidebar > .notify
${MESSAGE ERREUR}                  La date de fin doit être supérieure à la date de début.

${BUTTON NEXT MONTH}              css=.listing-cal-next
*** Keywords ***
# ------------------------------------------
# COMMON
# ------------------------------------------
Ouvrir App
    Open Browser    ${URL}    ${NAVIGATEUR}
    Maximize Browser Window

Fermer les navigateurs restants
    Run Keyword And Ignore Error    Close All Browsers

Ouvrir le navigateur et accéder à l'application
    Fermer les navigateurs restants
    Wait Until Keyword Succeeds    2x     3s    Ouvrir App
    Wait Until Page Contains Element    tag=body    15s

Se connecter
    [Arguments]    ${user}    ${pass}

    # Saisir les identifiants
    Click Element    ${LIEN SE CONNECTER}
    Wait Until Element Is Visible    ${CHAMP NOM UTILISATEUR}
    Clear Element Text    ${CHAMP NOM UTILISATEUR}
    Clear Element Text    ${CHAMP MOT DE PASSE}
    Input Text    ${CHAMP NOM UTILISATEUR}    ${user}
    Input Text    ${CHAMP MOT DE PASSE}       ${pass}
    Click Button    ${BOUTON VALIDER}

    # Vérifier la connexion
    Title Should Be    ${TITRE TABLEAU DE BORD VOYAGEUR}
    Wait Until Element Is Not Visible    ${MODAL LOGIN}    10s
    Wait Until Page Contains Element    ${BUTTON ACCUEIL}    10s

Retourner sur la page d'accueil
    Wait Until Element Is Visible    ${BUTTON ACCUEIL}    10s
    Click Element    ${BUTTON ACCUEIL}
    Wait Until Page Contains    ${TITRE ACCUEIL}    10s

Fermer l'application
    Close Browser

Préparer le test
    # Préparer l'utilisateur et ouvrir une annonce
    Ouvrir le navigateur et accéder à l'application
    Se connecter    ${UTILISATEUR VALIDE}    ${MOT DE PASSE VALIDE}
    Retourner sur la page d'accueil
    Trouver l'annonce    ${DESTINATION}
    Ouvrir l'annonce

# ------------------------------------------
# ACTIONS AVEC ANNONCE
# ------------------------------------------
Trouver l'annonce 
    [Arguments]     ${destination} 
    # Rechercher une annonce par destination 
    Wait Until Element Is Visible     ${BUTTON CHERCHER ANNONCE} 
    Run Keyword And Ignore Error
    ...    Wait Until Element Is Not Visible    id=homey-map-loading    20s
    Click Element     ${BUTTON CHERCHER ANNONCE} 
    Click Element     ${BAR DESTINATION} 
    Input Text     ${TEXT CHAMP DESTINATION}     ${destination} 
    Sleep     1s 
    Click Element     ${BUTTON CHERCHER} 
    Sleep     1s
   
Ouvrir l'annonce
    Click Element    ${ANNONCE}
    Sleep    1s

Récupérer les dates futures disponibles
    Wait Until Element Is Visible    ${CALENDRIER}    10s

    # Récupérer les dates futures disponibles
    ${timestamps}=    Execute JavaScript
    ...    return Array.from(document.querySelectorAll('#single-booking-search-calendar .single-listing-calendar-wrap:not([style*="display:none"]) li.day-available.future-day')).map(el => Number(el.dataset.timestamp));

    # Trouver les périodes de deux jours consécutifs
    ${paires}=    Evaluate
    ...    [(date, date + 86400) for date in $timestamps if date + 86400 in $timestamps]
    RETURN    ${paires}

Choisir des dates disponibles aléatoires
    Click Element    ${CHAMP DATE DEBUT}
    ${paires}    Récupérer les dates futures disponibles
    ${nombre_paires}=    Get Length    ${paires}

    IF    ${nombre_paires} == 0
        Click Button    ${BUTTON NEXT MONTH}
        ${paires}    Récupérer les dates futures disponibles
        ${nombre_paires}=    Get Length    ${paires}
        Should Be True    ${nombre_paires} > 0    Aucune période de deux jours consécutifs disponible.

    ELSE IF    ${nombre_paires} > 0
        Should Be True    ${nombre_paires} > 0    Aucune période de deux jours consécutifs disponible.

    END
    Should Be True    ${nombre_paires} > 0    Aucune période de deux jours consécutifs disponible.

    # Sélectionner une période aléatoire
    ${paire}=         Evaluate    random.choice($paires)    modules=random
    ${date_debut}=    Set Variable    ${paire}[0]
    ${date_fin}=      Set Variable    ${paire}[1]

    Click Element
    ...    xpath=//div[@id='single-booking-search-calendar']//li[@data-timestamp='${date_debut}' and contains(@class,'day-available')]

    Click Element
    ...    xpath=//div[@id='single-booking-search-calendar']//li[@data-timestamp='${date_fin}' and contains(@class,'day-available')]

Choisir le nombre de voyageurs
    # Choisir aléatoirement un ou deux voyageurs
    ${nombre_voyageurs}=    Evaluate    random.randint(1, 2)    modules=random

    Click Element    ${CHAMP VOYAGEURS}
    Wait Until Element Is Visible    ${BUTTON AJOUTER ADULTE}    10s

    FOR    ${index}    IN RANGE    ${nombre_voyageurs}
        Click Button    ${BUTTON AJOUTER ADULTE}
    END
    Click Button    ${BUTTON APPLIQUER VOYAGEURS}