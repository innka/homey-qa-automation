# ==========================================
# FILE: hote_confirme_reservation.robot
# Tests fonctionnels - PP-24 / PP-25 / PP-26 : confirmer une réservation et vérifier les statuts côté hôte et voyageur
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Setup      Préparer le test8
Test Teardown   Fermer l'application8

*** Variables ***
${ID_RESERVATION}    ${EMPTY}

*** Test Cases ***
Tester la confirmation d'une réservation et vérifier les statuts
    [Documentation]    Vérifier les informations de la réservation, sa confirmation et les statuts côté hôte et voyageur.
    [Tags]    US-08    PP-24    PP-25    PP-26

    # PP-24 : Vérifier les informations avant confirmation
    Ouvrir une réservation avec le statut    NOUVEAU

    # Mémoriser l'ID pour les vérifications suivantes
    ${reservation_id}=    Récupérer l'ID de la réservation
    Set Suite Variable    ${ID_RESERVATION}    ${reservation_id}

    Verifier les informations avant confirmation
    Log    ===== Fin de la vérification PP-24 =====

    # PP-25 : Confirmer et vérifier le statut côté hôte
    Confirmer une réservation
    Retourner au tableau réservations Hôte
    Run Keyword And Continue On Failure    Vérifier le statut d'une réservation    ${ID_RESERVATION}    PAIEMENT EN ATTENTE
    Log    ===== Fin de la vérification PP-25 =====

    # PP-26 : Vérifier le statut côté voyageur
    Se deconnecter
    Se connecter    ${UTILISATEUR VALIDE}    ${MOT DE PASSE VALIDE}
    Run Keyword And Continue On Failure    Vérifier le statut d'une réservation    ${ID_RESERVATION}    DISPONIBLE
    Log    ===== Fin de la vérification PP-26 =====