# ==========================================
# FILE: demande-voyageur_non_connecte.robot
# Tests fonctionnels - PP-12 : vérifier le comportement d'un visiteur lors d'une demande de réservation
# ==========================================

*** Settings ***
Resource        commun_US-07.resource
Test Teardown   Fermer l'application

*** Variables ***
${DEMANDE NON ENVOYEE}    xpath=//div[contains(text(),'Vous devez vous connecter pour effectuer une réservation')]

*** Keywords ***
Envoyer une demande de réservation
    Ouvrir le navigateur et accéder à l'application
    Trouver l'annonce    ${DESTINATION}
    Ouvrir l'annonce
    Choisir des dates disponibles aléatoires
    Choisir le nombre de voyageurs
    Click Button    ${BUTTON DEMANDE RESERVATION}
    Wait Until Element Is Visible    ${DEMANDE NON ENVOYEE}    10s

*** Test Cases ***
Tester l'envoi d'une demande de réservation en tant que voyageur non connecté
    [Documentation]    Vérifier qu'un voyageur non connecté ne peut pas envoyer une demande de réservation pour une annonce.
    [Tags]    US-07    PP-12
    
    Envoyer une demande de réservation
