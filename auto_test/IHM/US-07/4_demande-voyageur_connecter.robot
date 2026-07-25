# ==========================================
# FILE: demande-voyageur_connecter.robot
# Tests fonctionnels - PP-11 : vérifier qu'un Voyageur connecté peut envoyer une demande de réservation
# ==========================================

*** Settings ***
Resource        commun_US-07.resource
Test Setup      Préparer le test
Test Teardown   Fermer l'application

*** Keywords ***
Envoyer une demande de réservation
    Choisir des dates disponibles aléatoires
    Choisir le nombre de voyageurs
    Click Button    ${BUTTON DEMANDE RESERVATION}
    Wait Until Element Is Visible    ${DEMANDE ENVOYEE}    10s

*** Test Cases ***
Tester l'envoi d'une demande de réservation en tant que voyageur connecté
    [Documentation]    Vérifier qu'un voyageur connecté peut envoyer une demande de réservation pour une annonce.
    [Tags]    US-07    PP-11

    Envoyer une demande de réservation
