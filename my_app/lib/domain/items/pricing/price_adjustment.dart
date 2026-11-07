class PriceAdjustment {
  /// Valeur de l'ajustement
  final int amount;

  /// Règle appliquée qui a provoquée l'ajustement
  final String appliedRuleId;

  /// Explication excplicite du changement, à destination de l'utilisateur
  final String explications;

  /// Id de la ligne impactée par cet ajustement, si aucune valeur, remise globale non réimpactée sur chaque produit.
  final int? orderLineIndex;

  PriceAdjustment({
    required this.amount,
    required this.appliedRuleId,
    required this.explications,
    this.orderLineIndex,
  });
}
