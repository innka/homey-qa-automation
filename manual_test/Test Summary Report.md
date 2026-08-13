# Test Summary Report

| Élément                  | Valeur              |
| -------------------------- | ------------------- |
| **Auteur**           | Inna Pykhtina       |
| **Projet**           | Homey               |
| **Version**          | 3.0                 |
| **Type de document** | Test Summary Report |

---

# Projet

**Application :** Homey

**Module testé :** Réservations

## User Stories testées

* **US-07 – Faire une demande de réservation (P1)**
* **US-08 – Traiter une demande de réservation (P2)**

---

# Objectif

L'objectif de cette campagne de tests était de valider le processus complet de réservation d'un logement dans l'application Homey.

Les tests ont permis de vérifier l'ensemble du parcours utilisateur, depuis la création d'une demande de réservation par le voyageur jusqu'au traitement de cette demande par l'hôte.

Les fonctionnalités testées comprennent notamment :

* la création d'une demande de réservation ;
* la validation des dates disponibles ;
* le blocage des dates réservées ;
* la confirmation d'une réservation ;
* le refus d'une réservation ;
* l'ajout de frais supplémentaires ;
* l'ajout de remises ;
* le paiement d'une réservation ;
* l'annulation d'une réservation ;
* l'enregistrement des informations bancaires de l'hôte ;
* les transitions de statut de la réservation.

---

# Périmètre des tests

Les campagnes de tests couvrent les User Stories suivantes :

### US-07 – Faire une demande de réservation (P1)

Les scénarios testés concernent notamment :

* l'affichage des informations d'un logement ;
* la sélection des dates de séjour ;
* le calcul du prix de la réservation ;
* l'envoi d'une demande de réservation ;
* le blocage des dates réservées ;
* la création d'une réservation.

### US-08 – Traiter une demande de réservation (P2)

Les scénarios testés concernent notamment :

* la consultation des demandes de réservation par l'hôte ;
* la confirmation ou le refus d'une réservation ;
* l'ajout de frais ;
* l'ajout de remises ;
* le paiement d'une réservation ;
* l'annulation d'une réservation ;
* la gestion des informations bancaires ;
* la validation des changements de statut.

Les tests exécutés comprennent :

* des tests fonctionnels ;
* des tests système ;
* des tests de transition d'état ;
* des scénarios positifs ;
* des scénarios négatifs.

L'ensemble des tests a été réalisé manuellement.

---

# Résultats de la campagne de tests

| Indicateur             | Résultat |
| ---------------------- | --------: |
| Cas de test prévus    |        30 |
| Cas de test exécutés |        30 |
| Cas réussis           |        29 |
| Cas échoués          |         1 |
| Cas bloqués           |         0 |
| Cas non exécutés     |         0 |
| Taux d'exécution      |     100 % |
| Taux de réussite      |  96,67 % |

---

# Anomalies détectées

Une anomalie fonctionnelle a été identifiée au cours de la campagne de tests.

## Anomalie 1 — Validation d'une réservation sans paiement effectué

Lorsqu'un hôte n'a pas renseigné ses informations bancaires, le voyageur ne peut pas effectuer le paiement de la réservation, ce qui correspond au comportement attendu.

Cependant, le voyageur peut malgré tout utiliser l'action Marquer comme payé. Le système autorise alors le changement du statut de la réservation en RÉSERVÉ, alors qu'aucun paiement n'a été effectué.

Cette anomalie permet au voyageur de contourner le processus normal de paiement et de valider une réservation sans qu'aucune transaction n'ait eu lieu. Elle crée une incohérence entre le statut de la réservation et son état réel et constitue un risque important pour la gestion des réservations et le suivi des paiements.

L'anomalie a été documentée dans Jira.

---

# Évaluation des risques

Les principales fonctionnalités des User Stories US-07 et US-08 répondent globalement aux exigences fonctionnelles et permettent d'exécuter le processus principal de réservation.

L'anomalie identifiée présente un risque métier important, car elle permet de faire passer une réservation au statut RÉSERVÉ sans transaction réelle. Cette incohérence peut compromettre la fiabilité du suivi des paiements et des réservations.

Cette anomalie doit donc être corrigée avant toute mise en production.

---

# Conclusion

La campagne de tests des User Stories **US-07 – Faire une demande de réservation** et **US-08 – Traiter une demande de réservation** est terminée.

Au total, 30 **cas de test** ont été conçus, exécutés et analysés. Les scénarios couvrent les principaux parcours fonctionnels du module **Réservations**, notamment la création d'une demande, son traitement par l'hôte, le paiement, l'annulation ainsi que les différentes transitions de statut.

Les tests ont permis de valider la majorité des fonctionnalités prévues et d'identifier une anomalie fonctionnelle nécessitant une correction.

Dans son état actuel, le module présente un niveau de qualité satisfaisant pour les fonctionnalités principales. Toutefois, l'anomalie détectée doit être corrigée avant toute mise en production afin de garantir la cohérence des règles métier et la fiabilité du processus de réservation.
