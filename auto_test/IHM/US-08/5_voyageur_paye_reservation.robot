# ==========================================
# FILE: voyageur_paye_reservation.robot
# Tests fonctionnels - PP-34 / PP-35 / PP-39 : accéder au paiement, payer une réservation et
# afficher les informations bancaires de l'hôte
# Tests fonctionnels - PP-43 / PP-44 : vérifier le statut RÉSERVÉ côté hôte et côté voyageur
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Teardown   Fermer l'application8

*** Variables ***
${STATUT ANNONCE}                       DISPONIBLE
${STATUT RESERVATION APRES PAIEMENT}    RÉSERVÉ

*** Keywords ***
Verifier l'info de l'annonce avant payer
    Ouvrir une réservation avec le statut    ${STATUT ANNONCE}
    Verifier les informations avant confirmation

*** Test Cases ***
Tester le bouton « Payer maintenant » et le paiement d'une réservation
    [Documentation]    La page de paiement est affichée avec le nombre de nuits, le prix par nuit et le taux d'imposition.
    [Tags]    US-08    PP-34    PP-35    PP-39    PP-43    PP-44

    # PP-34 : Vérifier les informations avant paiement
    Ouvrir le navigateur et accéder à l'application
    Se connecter    ${UTILISATEUR VALIDE}    ${MOT DE PASSE VALIDE}
    Run Keyword And Continue On Failure    Verifier l'info de l'annonce avant payer
    Log    ===== Fin de la vérification PP-34 =====

    # PP-39 : Vérifier les informations bancaires de l'hôte
    Acces au paiement
    Run Keyword And Continue On Failure    Verifier les informations bancaires de l'hôte
    Log    ===== Fin de la vérification PP-39 =====

    # PP-35 : Marquer la réservation comme payée
    Click Element    xpath=//a[contains(text(),'Retour')]
    Run Keyword And Continue On Failure    Marquer comme payé

    # Mémoriser l'ID pour les vérifications suivantes
    ${reservation_id}=    Récupérer l'ID de la réservation
    Log    Réservation testée : ${reservation_id}
    Log    ===== Fin de la vérification PP-35 =====

    # PP-44 : Vérifier le statut côté voyageur
    Retourner au tableau réservations Voyageur
    Run Keyword And Continue On Failure    
    ...    Vérifier le statut d'une réservation    ${reservation_id}    ${STATUT RESERVATION APRES PAIEMENT}
    Log    ===== Fin de la vérification PP-44 =====

    # PP-43 : Vérifier le statut côté hôte
    Se deconnecter
    Se connecter    ${HOTE_EMAIL}    ${HOTE_PASSWORD}
    Retourner au tableau réservations Hôte

    Run Keyword And Continue On Failure
    ...    Vérifier le statut d'une réservation    ${reservation_id}    ${STATUT RESERVATION APRES PAIEMENT}
    Log    ===== Fin de la vérification PP-43 =====
