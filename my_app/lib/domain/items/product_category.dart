// Classe correspondant à la catégorie d'un produit.
// Plus évolutif qu'un type de client ou status d'une commande -> pas d'énum
// On créé cependant une classe a part entière pour faciliter l'évolutivité sans trop complexifier le code
class ProductCategory {
  final String name;

  const ProductCategory({required this.name});
}
