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
  String title;
  bool paid;
  bool homeworkDone;

  RoadmapNode(this.title, {required this.paid, required this.homeworkDone});
}
