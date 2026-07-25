# ==========================================
# FILE: nouvelle_demande_reservation_hote.robot
# Tests fonctionnels - PP-22 / PP-23 : vérifier le statut et les informations d'une nouvelle réservation côté hôte
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Setup      Préparer le test8
Test Teardown   Fermer l'application8

*** Keywords ***
Verifier les informations de la réservation
    ${reservation}=    Trouver une réservation avec le statut    NOUVEAU
    # Récupérer les informations de la réservation
    ${date_debut}=    Get Text    ${reservation}/td[@data-label='Arrivée']
    ${date_fin}=      Get Text    ${reservation}/td[@data-label='Départ']
    ${voyageurs}=     Get Text    ${reservation}/td[@data-label='Voyageurs']
    ${animaux}=       Get Text    ${reservation}/td[@data-label='Animaux domestiques']
    ${total}=         Get Text    ${reservation}/td[@data-label='Total']

    # Vérifier les dates
    ${date_aujourdhui}=    Get Current Date    result_format=%Y-%m-%d
    Should Be True    '${date_debut}' > '${date_aujourdhui}'
    Should Be True    '${date_fin}' > '${date_debut}'

    # Vérifier le nombre de voyageurs
    ${voyageurs}=    Convert To Integer    ${voyageurs}
    Should Be True    ${voyageurs} > 0

    # Vérifier l'information sur les animaux
    ${animaux}=    Convert To Lower Case    ${animaux}
    Should Be True    '${animaux}' == 'oui' or '${animaux}' == 'non'

    # Vérifier le montant total
    ${total}=    Remove String    ${total}    €
    ${total}=    Convert To Number    ${total}
    Should Be True    ${total} > 0

*** Test Cases ***
Tester le statut et les informations d'une réservation côté hôte
    [Documentation]    Vérifier le statut et les informations d'une nouvelle réservation côté hôte.
    [Tags]    US-08    PP-22    PP-23

    # PP-22 : Vérifier le statut NOUVEAU
    ${reservation}=    Trouver une réservation avec le statut    NOUVEAU
    Run Keyword And Continue On Failure    Element Should Contain    ${reservation}    NOUVEAU
    Log    ===== Fin de la vérification PP-22 =====

    # PP-23 : Vérifier les informations de la réservation
    Run Keyword And Continue On Failure    Verifier les informations de la réservation
    Log    ===== Fin de la vérification PP-23 =====