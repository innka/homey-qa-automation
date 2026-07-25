robot
# ==========================================
# FILE: add_frais_supplementaires.robot
# Tests fonctionnels - PP-30 / PP-31 : ajouter un ou plusieurs frais supplémentaires
# ==========================================

*** Settings ***
Resource        commun_US-08.resource
Test Setup      Préparer le test8
Test Teardown   Fermer l'application8

*** Variables ***
${BUTTON AJOUTER FRAIS}    css=aside.dashboard-sidebar button[data-target="#modal-extra-expenses"]

${NOM FRAIS}               xpath=//div[@id='modal-extra-expenses' and contains(@class,'in')]//input[contains(@class,'enter_expense_name')]
${VALEUR FRAIS}            xpath=//div[@id='modal-extra-expenses' and contains(@class,'in')]//input[contains(@class,'enter_expense_value')]
${BUTTON AJOUTER PLUS}     css=#modal-extra-expenses #add_more_expense
${ENREGISTRER FRAIS}       css=#modal-extra-expenses #save_expenses
${TOTAL}                   xpath=(//li[contains(@class,'payment-due')]/span)[1]

*** Keywords ***
Ajouter un frais supplémentaire
    [Arguments]    ${nom}    ${montant}

    # Récupérer le montant actuel
    ${prix_avant_texte}=    Get Text    ${TOTAL}
    ${prix_avant_texte}=    Remove String    ${prix_avant_texte}    €
    ${prix_avant}=    Convert To Number    ${prix_avant_texte}
    Log    Prix avant l'ajout du frais : ${prix_avant}

    # Calculer le nouveau total attendu
    ${frais_ajoute}=    Convert To Number    ${montant}
    ${prix_attendu}=    Evaluate    ${prix_avant} + ${frais_ajoute}
    Log    Prix attendu après l'ajout du frais : ${prix_attendu}

    Wait Until Element Is Visible    ${BUTTON AJOUTER FRAIS}    10s
    Wait Until Element Is Enabled    ${BUTTON AJOUTER FRAIS}    10s
    Click Button    ${BUTTON AJOUTER FRAIS}
    Wait Until Element Is Visible    ${NOM FRAIS}    10s

    # Ajouter le frais
    Input Text    ${NOM FRAIS}    ${nom}
    Input Text    ${VALEUR FRAIS}    ${montant}

    Click Element    ${BUTTON AJOUTER PLUS}
    Click Element    ${ENREGISTRER FRAIS}
    #Quiter le formuler 
    Press Keys    NONE    ESC

    # Vérifier la mise à jour du total
    Wait Until Keyword Succeeds    10s    500ms    Vérifier le total après ajout du frais    ${prix_attendu}
    ${prix_apres}=    Get Text    ${TOTAL}
    Log    Prix après l'ajout du frais : ${prix_apres}

Vérifier le total après ajout du frais
    [Arguments]    ${prix_attendu}

    ${prix_actuel}=    Get Text    ${TOTAL}
    ${prix_actuel}=    Remove String    ${prix_actuel}    €
    ${prix_actuel}=    Convert To Number    ${prix_actuel}
    Should Be Equal As Numbers    ${prix_actuel}    ${prix_attendu}

*** Test Cases ***

Tester l'ajout d'un ou plusieurs frais supplémentaires
    [Documentation]    Test fonctionnel - PP-30 / PP-31 : ajouter un ou plusieurs frais supplémentaires
    [Tags]    US-08    PP-30    PP-31

    # PP-30 : Ajouter un frais
    Ouvrir une réservation avec le statut    NOUVEAU
    Run Keyword And Continue On Failure    Ajouter un frais supplémentaire    Ménage    40.00
    Log    ===== Fin de la vérification PP-30 =====

    # PP-31 : Ajouter un second frais
    Run Keyword And Continue On Failure    Ajouter un frais supplémentaire    Parking    20.00
    Log    ===== Fin de la vérification PP-31 =====

