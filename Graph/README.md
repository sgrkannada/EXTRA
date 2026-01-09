# 📊 Social Network Graph - Educational Tool

## 🎯 Overview
This educational project teaches students how **graphs are used in social media platforms** like Facebook, Instagram, LinkedIn, and Twitter. It includes both **Java code implementation** and an **interactive HTML visualization** with animations.

## 📁 Project Structure
```
Graph/
├── src/
│   ├── SocialNetworkGraph.java    # Core graph data structure
│   └── SocialNetworkDemo.java     # Interactive console demo
├── visualization.html              # Interactive web visualization
└── README.md                       # This file
```

---

## 🧠 Key Concepts Taught

### 1. What is a Graph?
- **Nodes (Vertices)**: Represent entities (users in social media)
- **Edges**: Represent relationships (friendships/connections)

### 2. Types of Graphs in Social Media
| Platform | Graph Type | Example |
|----------|-----------|---------|
| Facebook | Undirected | Mutual friendships |
| LinkedIn | Undirected | Connections |
| Twitter | Directed | Following (A→B doesn't mean B→A) |
| Instagram | Directed | Followers |

### 3. Data Structures Used
- **Adjacency List**: Efficient storage of connections
- **HashMap/HashSet**: O(1) lookup for friends

### 4. Algorithms Demonstrated
| Algorithm | Use Case | Complexity |
|-----------|----------|------------|
| BFS | Finding shortest path, friend suggestions | O(V + E) |
| DFS | Finding connected components, communities | O(V + E) |
| Shortest Path | Degrees of separation | O(V + E) |

---

## 🚀 How to Run

### Option 1: Java Console Application
```bash
# Navigate to project directory
cd Graph

# Compile Java files
javac src/*.java -d out

# Run the demo
java -cp out SocialNetworkDemo
```

### Option 2: Interactive Web Visualization
Simply open `visualization.html` in any modern web browser!

---

## 💻 Java Code Features

### SocialNetworkGraph.java
The core graph implementation includes:

```java
// Key Methods
addUser(username, name, age)     // Add a node
addFriendship(user1, user2)      // Add an edge
getFriends(username)             // Get adjacent nodes
getMutualFriends(user1, user2)   // Find common friends
bfs(startUser)                   // Breadth-first search
dfs(startUser)                   // Depth-first search
findShortestPath(start, end)     // Degrees of separation
suggestFriends(username)         // "People you may know"
findInfluencers(topN)            // Most connected users
detectCommunities()              // Connected components
```

### Example Usage:
```java
SocialNetworkGraph network = new SocialNetworkGraph();

// Add users (nodes)
network.addUser("alice", "Alice Johnson", 25);
network.addUser("bob", "Bob Smith", 28);
network.addUser("charlie", "Charlie Brown", 22);

// Add friendships (edges)
network.addFriendship("alice", "bob");
network.addFriendship("bob", "charlie");

// Find shortest path
network.findShortestPath("alice", "charlie");
// Output: alice → bob → charlie (2 degrees)

// Get friend suggestions
network.suggestFriends("alice");
// Output: charlie (1 mutual friend)
```

---

## 🎨 Visualization Features

The HTML visualization provides:

### Interactive Controls
- ➕ Add new users (nodes)
- 🔗 Create friendships (edges)
- 🖱️ Drag nodes to rearrange
- 🎚️ Adjust animation speed

### Algorithm Animations
- **BFS**: Watch level-by-level exploration
- **DFS**: See deep-first traversal with backtracking
- **Shortest Path**: Visualize path finding
- **Friend Suggestions**: See mutual friend analysis

### Real-time Information
- 📊 Network statistics
- 📋 Activity log
- ☕ Java code for each operation
- 📖 Algorithm explanations

---

## 📚 Learning Objectives

After using this tool, students will understand:

1. **Graph Representation**
   - How to store relationships efficiently
   - Adjacency list vs. Adjacency matrix trade-offs

2. **Graph Traversal**
   - BFS: Level-by-level exploration
   - DFS: Deep exploration with backtracking

3. **Real-World Applications**
   - How "People You May Know" works
   - How to calculate degrees of separation
   - How to detect communities/clusters

4. **Algorithm Analysis**
   - Time complexity: O(V + E)
   - Space complexity considerations

---

## 🔬 Exercises for Students

### Exercise 1: Add Directed Graph Support
Modify the code to support Twitter-style following (directed edges).

### Exercise 2: Implement PageRank
Add a simplified PageRank algorithm for influence scoring.

### Exercise 3: Community Detection
Implement a more sophisticated clustering algorithm.

### Exercise 4: Weighted Edges
Add relationship strength (close friend, acquaintance, etc.).

---

## 🎓 Teaching Tips

1. **Start with visualization**: Let students interact before showing code
2. **Use real examples**: "How does Facebook suggest friends?"
3. **Compare algorithms**: Run BFS and DFS on the same graph
4. **Discuss complexity**: Why is adjacency list better than matrix?
5. **Relate to real data**: Facebook has billions of nodes!

---

## 📝 Sample Class Discussion Questions

1. Why do social networks use graphs instead of tables?
2. What's the difference between undirected (Facebook) and directed (Twitter) graphs?
3. How many degrees of separation exist between you and any person on Facebook?
4. Why might BFS be better than DFS for finding shortest paths?
5. How would you modify this to handle a billion users?

---

## 🛠️ Technologies Used

- **Java**: Core graph implementation
- **HTML/CSS/JavaScript**: Interactive visualization
- **SVG**: Graph rendering
- **Force-directed layout**: Automatic node positioning

---

## 📖 Further Reading

- [Graph Theory Basics](https://en.wikipedia.org/wiki/Graph_theory)
- [Facebook's TAO System](https://research.facebook.com/publications/tao-facebooks-distributed-data-store-for-the-social-graph/)
- [Six Degrees of Separation](https://en.wikipedia.org/wiki/Six_degrees_of_separation)
- [PageRank Algorithm](https://en.wikipedia.org/wiki/PageRank)

---

## 📄 License
Educational use - Free for teaching and learning!

---

Made with ❤️ for Computer Science Education
