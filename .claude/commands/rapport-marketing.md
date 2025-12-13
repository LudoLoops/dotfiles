# /rapport-marketing

Génère un rapport marketing quotidien à partir des commits Git pour les parties prenantes.

Analyse tous les commits du jour, les catégorise par impact, et crée un résumé professionnel mettant en évidence :
- Les nouvelles fonctionnalités et améliorations utilisateur
- Les améliorations techniques et optimisations
- Le statut de version et de déploiement
- Les métriques clés et l'impact

La sortie est formatée pour la communication marketing/parties prenantes (langage non-technique).

## Utilisation

```bash
/rapport-marketing              # Générer le rapport d'aujourd'hui
/rapport-marketing --date 2025-12-09  # Date spécifique
/rapport-marketing --range 7j         # 7 derniers jours
/rapport-marketing --html       # Exporter en HTML
```

## Ce que cette commande fait

1. Récupère tous les commits de la période spécifiée
2. Les catégorise : Nouvelles fonctionnalités, Améliorations, Technique, Correctifs
3. Traduit les messages de commit en langage marketing
4. Génère les informations de version et statut de déploiement
5. Met en évidence les réalisations clés et les métriques
6. Formate le rapport en markdown professionnel

## Format de sortie

```
📊 Rapport Daily - ProNeXus Xtimator v1.1.8

✨ Nouveautés
🛠️ Améliorations Techniques
📈 Impact & Métriques
✅ Statut de Déploiement
```

Parfait pour :
- Présentations aux stakeholders
- Rapports marketing internes
- Communication client
- Newsletter produit
