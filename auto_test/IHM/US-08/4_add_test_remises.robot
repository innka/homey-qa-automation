# ==========================================
# FILE: add_test_remises.robot
# Tests fonctionnels - PP-32 / PP-33 : ajouter une ou plusieurs remises
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Setup      Préparer le test8
Test Teardown   Fermer l'application8

*** Variables ***
${BUTTON AJOUTER REMISE}         css=aside.dashboard-sidebar button[data-target="#modal-discount"]

${NOM REMISE}                    xpath=//div[@id='modal-discount' and contains(@class,'in')]//input[contains(@class,'enter_discount_name')]
${VALEUR REMISE}                 xpath=//div[@id='modal-discount' and contains(@class,'in')]//input[contains(@class,'enter_discount_value')]

${BUTTON AJOUTER PLUS REMISE}    css=#modal-discount #add_more_discount
${ENREGISTRER REMISE}            css=#modal-discount #save_discounts

${TOTAL}                         xpath=(//li[contains(@class,'payment-due')]/span)[1]

*** Keywords ***

Ajouter une remise
    [Arguments]    ${nom}    ${montant}

    # Récupérer le montant actuel
    ${prix_avant_texte}=    Get Text    ${TOTAL}
    ${prix_avant_texte}=    Remove String    ${prix_avant_texte}    €
    ${prix_avant}=    Convert To Number    ${prix_avant_texte}
    Log    Prix avant l'ajout de la remise : ${prix_avant}

    # Calculer le nouveau total attendu
    ${remise_ajoutee}=    Convert To Number    ${montant}
    ${prix_attendu}=    Evaluate    ${prix_avant} - ${remise_ajoutee}
    Log    Prix attendu après l'ajout de la remise : ${prix_attendu}
    
    Wait Until Element Is Visible    ${BUTTON AJOUTER REMISE}    10s
    Wait Until Element Is Enabled    ${BUTTON AJOUTER REMISE}    10s
    Click Button    ${BUTTON AJOUTER REMISE}
    Wait Until Element Is Visible    ${NOM REMISE}    10s

    # Ajouter la remise
    Input Text    ${NOM REMISE}    ${nom}
    Input Text    ${VALEUR REMISE}    ${montant}

    Click Element    ${BUTTON AJOUTER PLUS REMISE}
    Click Element    ${ENREGISTRER REMISE}
    
    #Quiter le formuler
    Press Keys    NONE    ESC

    # Vérifier la mise à jour du total
    Wait Until Keyword Succeeds    10s    500ms    Vérifier le total après ajout de la remise    ${prix_attendu}
    ${prix_apres}=    Get Text    ${TOTAL}
    Log    Prix après l'ajout de la remise : ${prix_apres}

Vérifier le total après ajout de la remise
    [Arguments]    ${prix_attendu}

    ${prix_actuel}=    Get Text    ${TOTAL}
    ${prix_actuel}=    Remove String    ${prix_actuel}    €
    ${prix_actuel}=    Convert To Number    ${prix_actuel}
    Should Be Equal As Numbers    ${prix_actuel}    ${prix_attendu}

*** Test Cases ***

Tester l'ajout d'une ou plusieurs remises
    [Documentation]    Test fonctionnel - PP-32 / PP-33 : ajouter une ou plusieurs remises
    [Tags]    US-08    PP-32    PP-33

    Ouvrir une réservation avec le statut    NOUVEAU

    # PP-32 : Ajouter une remise
    Run Keyword And Continue On Failure    Ajouter une remise    Promotion    15.00
    Log    ===== Fin de la vérification PP-32 =====

    # PP-33 : Ajouter une seconde remise
    Run Keyword And Continue On Failure    Ajouter une remise    Fidélité    10.00
    Log    ===== Fin de la vérification PP-33 =====
