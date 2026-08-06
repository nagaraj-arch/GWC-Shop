class FlavorModel {
  final int id;
  final String name;
  final String description;
  final String image;

  FlavorModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });
}

final dummyFlavors = [
  FlavorModel(
    id: 1,
    name: "Raita",
    description: "Cooling yogurt with herbs",
    image: "https://picsum.photos/80?1",
  ),
  FlavorModel(
    id: 2,
    name: "Mint Chutney",
    description: "Fresh mint chutney",
    image: "https://picsum.photos/80?2",
  ),
  FlavorModel(
    id: 3,
    name: "Gravy",
    description: "Rich masala gravy",
    image: "https://picsum.photos/80?3",
  ),
];