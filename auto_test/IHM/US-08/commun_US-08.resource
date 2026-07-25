# ------------------------------------------
# FILE: commun_US-08.resource
# ------------------------------------------
# Compatible avec :
# - hote_confirme_reservation.robot 
# - hote_refuse_reservation.robot 
# - voyageur_paye_reservation.robot 
# - voyageur_annule_reservation.robot 
# - nouvelle_demande_reservation_hote.robot 
# - add_frais_supplementaires.robot 
# - add_test_remises.robot 

*** Settings ***
Library           SeleniumLibrary
Library           DateTime
Library           String
Resource          ../US-07/commun_US-07.resource

*** Variables ***
# ------------------------------------------
# COMMON
# ------------------------------------------
${BUTTON SE DECONNECTER}            xpath=//div[contains(@class,'account-dropdown')]//a[contains(normalize-space(.),'Se déconnecter')]
${BUTTON USER MENU}                 css=.account-loggedin

# ------------------------------------------
# LOGIN HÔTE
# ------------------------------------------
${HOTE_EMAIL}                       Sera
${HOTE_PASSWORD}                    robot1

# ------------------------------------------
# TABLEAU DE BORD HÔTE / VOYAGEUR
# ------------------------------------------
${PREMIERE_RESERVATION_NOUVELLE}    xpath=(//tbody/tr[td[@data-label='Statut']//span[normalize-space(.)='NOUVEAU']])[1]
${BUTTON RESERVATIONS}              xpath=(//a[contains(text(),'Réservations')])[3]
${BUTTON VOYAGES}                   xpath=(//a[contains(text(),'Voyages')])[3]

# ------------------------------------------
# PAGE AVEC UNE ANNONCE
# ------------------------------------------
${BUTTON CONFIRMER RESERVATION}     css=.confirm-offsite-reservation:nth-child(2)

# ------------------------------------------
# RÉSERVATION
# ------------------------------------------
${BUTTON MARQUER COMME PAYE}        css=.mark-as-paid

*** Keywords ***
# ------------------------------------------
# COMMON
# ------------------------------------------
Cliquer sur Se déconnecter
    Mouse Over    ${BUTTON USER MENU}
    Wait Until Element Is Visible    ${BUTTON SE DECONNECTER}    3s
    Click Element    ${BUTTON SE DECONNECTER}

Se deconnecter
    Press Keys    NONE    HOME

    Wait Until Element Is Visible    ${BUTTON USER MENU}    15s
    Mouse Over    ${BUTTON USER MENU}
    Wait Until Keyword Succeeds    3x    1s    Cliquer sur Se déconnecter
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    15s

Préparer le test8
    Ouvrir le navigateur et accéder à l'application
    Se connecter    ${HOTE_EMAIL}    ${HOTE_PASSWORD}

Fermer l'application8
    Close All Browsers

# ------------------------------------------
# TABLEAU DE BORD HÔTE / VOYAGEUR
# ------------------------------------------
Trouver une réservation avec le statut
    [Arguments]    ${statut}

    ${reservation}=    Set Variable    xpath=(//tbody/tr[td[@data-label='Statut']//span[normalize-space(.)="${statut}"]])[1]
    Wait Until Element Is Visible    ${reservation}    10s
    Log    La réservation avec le statut ${statut} a été trouvée : ${reservation}
    RETURN    ${reservation}

Vérifier le statut d'une réservation
    [Arguments]    ${reservation_id}    ${statut_attendu}

    ${reservation}=    Set Variable    xpath=//tbody/tr[td[@data-label='ID'][contains(normalize-space(.),'${reservation_id}')]]
    Wait Until Element Is Visible    ${reservation}    10s
    Element Should Contain    ${reservation}/td[@data-label='Statut']    ${statut_attendu}

Retourner au tableau réservations Hôte
    Click Element    ${BUTTON RESERVATIONS}
    Wait Until Element Is Visible    xpath=//tbody/tr    10s

Retourner au tableau réservations Voyageur
    Click Element    ${BUTTON VOYAGES}
    Wait Until Element Is Visible    xpath=//tbody/tr    10s

# ------------------------------------------
# PAGE AVEC UNE ANNONCE
# ------------------------------------------
Ouvrir une réservation avec le statut
    [Arguments]    ${statut}

    ${reservation}=    Trouver une réservation avec le statut    ${statut}

    IF    $statut == 'NOUVEAU'
        Click Element    ${reservation}//a[normalize-space(.)='Confirmer']
    ELSE IF    $statut == 'DISPONIBLE'
        Click Element    ${reservation}//a[contains(text(),'Payez maintenant')]
    ELSE IF    $statut == 'PAIEMENT EN ATTENTE'
        Click Element    ${reservation}//a[contains(text(),'Détails')]
    ELSE IF    $statut == "À L'ÉTUDE"
        Click Element    ${reservation}//a[contains(text(),'Détails')]
    END

Récupérer l'ID de la réservation
    ${reservation_id}=    Get Value    id=resrv_id
    Log    ID de la réservation : ${reservation_id}
    RETURN    ${reservation_id}

Confirmer une réservation
    Click Button    ${BUTTON CONFIRMER RESERVATION}

Verifier les informations avant confirmation
    # Récupérer les dates
    ${date_debut}=    Get Text    xpath=//li[contains(normalize-space(.),'Arrivée:')]/strong

    ${date_fin}=    Get Text    xpath=//li[contains(normalize-space(.),'Départ:')]/strong

    # Calculer le nombre de nuits attendu
    ${date_debut_epoch}=    Convert Date    ${date_debut}    epoch
    ${date_fin_epoch}=      Convert Date    ${date_fin}      epoch
    ${nb_nuits_attendu}=    Evaluate    int((${date_fin_epoch} - ${date_debut_epoch}) / 86400)

    # Récupérer le nombre de nuits affiché
    ${texte_nuits}=    Get Text     xpath=//li[contains(normalize-space(.),'nuit')]
    ${nb_nuits_affiche}=    Replace String Using Regexp    ${texte_nuits}    .*?([0-9]+).*    \\1
    ${nb_nuits_affiche}=    Convert To Integer    ${nb_nuits_affiche}
    Log    Nombre de nuits affiché : ${nb_nuits_affiche}

    Should Be Equal As Integers
    ...    ${nb_nuits_affiche}
    ...    ${nb_nuits_attendu}
    Log    Nombre de nuits affiché : ${nb_nuits_affiche}
    # Vérifier le nombre de nuits
    Should Be Equal As Integers    ${nb_nuits_affiche}    ${nb_nuits_attendu}

    # Vérifier le prix par nuit
    ${ligne_prix}=    Get Text    xpath=(//div[@class='payment-list']//li[contains(.,'€ x')])[1]
    Should Not Be Empty    ${ligne_prix}

    # Vérifier le taux d'imposition
    ${ligne_impots}=    Get Text    xpath=(//div[@class='payment-list']//li[contains(.,'Impôts')])[1]
    Should Match Regexp    ${ligne_impots}    Impôts\\s+\\d+(\\.\\d+)?%
    Log    Succès les informations avant confirmation

# ------------------------------------------
# RÉSERVATION D'ANNONCE
# ------------------------------------------
Verifier les informations bancaires de l'hôte
    Wait Until Page Contains    information de paiement    10s

    Page Should Contain    Méthode
    Page Should Contain    Virement bancaire

    Page Should Contain    Nom du bénéficiaire
    Page Should Contain    Adresse
    Page Should Contain    Code IBAN
    Page Should Contain    SWIFT
    Page Should Contain    Nom de banque
    Page Should Contain    Adresse de la banque

Acces au paiement
    ${reservation_id}=    Récupérer l'ID de la réservation
    Click Element    css=.btn-success:nth-child(2)

Verifier l'info bancaires
    Wait Until Page Contains    information de paiement    10s

    ${beneficiaire}=      Get Text    xpath=//li[strong[normalize-space(.)='Nom du bénéficiaire']]
    ${adresse}=           Get Text    xpath=//li[strong[normalize-space(.)='Adresse']]
    ${iban}=              Get Text    xpath=//li[strong[normalize-space(.)='Code IBAN']]
    ${swift}=             Get Text    xpath=//li[strong[normalize-space(.)='SWIFT']]
    ${banque}=            Get Text    xpath=//li[strong[normalize-space(.)='Nom de banque']]
    ${adresse_banque}=    Get Text    xpath=//li[strong[normalize-space(.)='Adresse de la banque']]

    Should Not Match Regexp    ${beneficiaire}      ^Nom du bénéficiaire\\s*$
    Should Not Match Regexp    ${adresse}           ^Adresse\\s*$
    Should Not Match Regexp    ${iban}              ^Code IBAN\\s*$
    Should Not Match Regexp    ${swift}             ^SWIFT\\s*$
    Should Not Match Regexp    ${banque}            ^Nom de banque\\s*$
    Should Not Match Regexp    ${adresse_banque}    ^Adresse de la banque\\s*$
    Log    Succès l'info bancaires

Marquer comme payé
    Click Element    ${BUTTON MARQUER COMME PAYE}

    # Confirmer l'action
    Wait Until Element Is Visible
    ...    xpath=//div[contains(@class,'bootbox') and contains(@class,'in')]//button[@data-bb-handler='confirm']    10s

    Click Element    xpath=//div[contains(@class,'bootbox') and contains(@class,'in')]//button[@data-bb-handler='confirm']

    # Vérifier le statut
    Wait Until Element Is Visible    
    ...    xpath=//aside[contains(@class,'dashboard-sidebar')]//span[contains(@class,'btn-success-outlined')]    10s
    Log    La réservation a été marquée comme payée avec succès. Statut : RÉSERVÉ