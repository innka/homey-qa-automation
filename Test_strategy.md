# Test Strategy

## Approche de test

L'approche de test choisie est basée sur les risques (**Risk Based Testing - RBT**).

Cette approche consiste à identifier les risques potentiels ainsi que les exigences critiques du projet, puis à définir les activités de test en fonction de leur niveau d'importance.

Les efforts de test sont ainsi concentrés sur les fonctionnalités présentant les risques les plus élevés afin d'assurer une couverture optimale des éléments critiques du projet.

Plus le risque de défaillance d'une exigence est important, plus l'effort de test associé est élevé.

**Principe appliqué :**  
> Pas de risque → Pas de test.

---

# Stratégie de test par priorité

## Exigences P1

### Tests manuels
- Couvrir les cas nominaux et les cas d'exception.
- Les cas de test sont conçus et implémentés.

### Tests de non-régression automatisés
- Couvrir les cas nominaux et les cas d'exception.

### Objectifs qualité
- Atteindre 100% de réussite des cas de test.
- Aucun défaut bloquant ne doit être présent.
- Aucun défaut majeur ne doit être présent.
- Limiter les défauts mineurs à moins de 6.

Les tests P1 sont prioritaires et doivent être exécutés en premier afin d'identifier rapidement les défauts critiques.

---

## Exigences P2

### Tests manuels
- Couvrir les cas nominaux et les cas d'exception.
- Les cas de test sont conçus et implémentés.

### Tests de non-régression automatisés
- Se concentrer principalement sur les cas nominaux.

### Objectifs qualité
- Atteindre 80% de réussite des cas de test.
- Ne pas dépasser 1 défaut majeur.
- Limiter les défauts mineurs à moins de 12.

Les tests P2 sont réalisés après les tests P1, en mettant l'accent sur les fonctionnalités essentielles.

---

## Exigences P3

### Tests manuels
- Se concentrer principalement sur les cas nominaux.
- Les cas de test sont conçus mais ne sont pas implémentés.

### Tests de non-régression automatisés
- Non applicables.

### Objectifs qualité
- Atteindre au minimum 50% de réussite des cas de test.
- Aucun défaut bloquant n'est acceptable.
- Les défauts majeurs sont tolérés mais doivent être documentés.
- Les défauts mineurs sont tolérés et doivent être surveillés.

Les tests P3 sont moins prioritaires, mais permettent d'assurer une couverture complémentaire des fonctionnalités moins critiques.

---

## Conclusion

Cette stratégie permet de prioriser les activités de test selon l'importance et le niveau de risque des fonctionnalités.

Elle garantit une détection précoce des défauts majeurs tout en optimisant les ressources disponibles pour les activités de test.