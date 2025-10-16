class Roadmap {
  List<RoadmapNode> nodes = [];

  void addNode(RoadmapNode node) {
    nodes.add(node);
  }

  void removeNode(RoadmapNode node) {
    nodes.remove(node);
  }

  void removeNodeAtIndex(int index) {
    nodes.removeAt(index);
  }
}

class RoadmapNode {
  final String title;
  final bool paid;
  final bool homeworkDone;

  const RoadmapNode(this.title, {required this.paid, required this.homeworkDone});
}
