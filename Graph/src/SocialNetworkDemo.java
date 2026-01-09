import java.io.*;
import java.util.*;

/**
 * Social Network Demo - Main Application
 * 
 * This program demonstrates all graph operations used in social media
 * and generates visualization data for the HTML interface.
 */
public class SocialNetworkDemo {
    
    private static SocialNetworkGraph network;
    private static Scanner scanner;
    
    public static void main(String[] args) {
        network = new SocialNetworkGraph();
        scanner = new Scanner(System.in);
        
        System.out.println("╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║      📱 SOCIAL NETWORK GRAPH - Educational Demo 📱           ║");
        System.out.println("║                                                              ║");
        System.out.println("║   Learn how social media platforms use graphs to:            ║");
        System.out.println("║   • Store user connections (Adjacency List)                  ║");
        System.out.println("║   • Find friends of friends (BFS/DFS)                        ║");
        System.out.println("║   • Suggest new connections (Graph Traversal)                ║");
        System.out.println("║   • Calculate degrees of separation (Shortest Path)          ║");
        System.out.println("╚══════════════════════════════════════════════════════════════╝");
        System.out.println();
        
        // Create sample social network
        createSampleNetwork();
        
        // Interactive menu
        runInteractiveMenu();
        
        scanner.close();
    }
    
    /**
     * Creates a sample social network with users and connections
     */
    private static void createSampleNetwork() {
        System.out.println("\n🔧 Creating Sample Social Network...\n");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        
        // Add users (nodes)
        network.addUser("alice", "Alice Johnson", 25);
        network.addUser("bob", "Bob Smith", 28);
        network.addUser("charlie", "Charlie Brown", 22);
        network.addUser("diana", "Diana Ross", 30);
        network.addUser("eve", "Eve Wilson", 27);
        network.addUser("frank", "Frank Miller", 35);
        network.addUser("grace", "Grace Lee", 24);
        network.addUser("henry", "Henry Davis", 29);
        network.addUser("ivy", "Ivy Chen", 26);
        network.addUser("jack", "Jack Taylor", 31);
        
        System.out.println("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("Adding Friendships (Edges):");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
        
        // Add friendships (edges)
        network.addFriendship("alice", "bob");
        network.addFriendship("alice", "charlie");
        network.addFriendship("alice", "diana");
        network.addFriendship("bob", "charlie");
        network.addFriendship("bob", "eve");
        network.addFriendship("charlie", "frank");
        network.addFriendship("diana", "eve");
        network.addFriendship("diana", "grace");
        network.addFriendship("eve", "frank");
        network.addFriendship("eve", "henry");
        network.addFriendship("frank", "grace");
        network.addFriendship("grace", "henry");
        network.addFriendship("henry", "ivy");
        network.addFriendship("ivy", "jack");
        network.addFriendship("jack", "alice");
        
        // Export initial state for visualization
        exportVisualizationData();
        
        System.out.println("\n✅ Sample network created and exported for visualization!");
    }
    
    /**
     * Interactive menu for demonstrating graph operations
     */
    private static void runInteractiveMenu() {
        while (true) {
            System.out.println("\n╔══════════════════════════════════════════════════════════════╗");
            System.out.println("║                    📋 MAIN MENU                              ║");
            System.out.println("╠══════════════════════════════════════════════════════════════╣");
            System.out.println("║  1. 👤 Add New User                                          ║");
            System.out.println("║  2. 🤝 Add Friendship                                        ║");
            System.out.println("║  3. 💔 Remove Friendship                                     ║");
            System.out.println("║  4. 👥 View Friends of User                                  ║");
            System.out.println("║  5. 🔗 Find Mutual Friends                                   ║");
            System.out.println("║  6. 🔍 BFS Traversal (Level by Level)                        ║");
            System.out.println("║  7. 🔍 DFS Traversal (Deep First)                            ║");
            System.out.println("║  8. 🛤️  Find Shortest Path (Degrees of Separation)           ║");
            System.out.println("║  9. 💡 Get Friend Suggestions                                ║");
            System.out.println("║ 10. ⭐ Find Influencers                                       ║");
            System.out.println("║ 11. 🏘️  Detect Communities                                    ║");
            System.out.println("║ 12. 📈 Network Statistics                                    ║");
            System.out.println("║ 13. 💾 Export for Visualization                              ║");
            System.out.println("║ 14. 📖 Learn: How Graphs Work                                ║");
            System.out.println("║  0. 🚪 Exit                                                  ║");
            System.out.println("╚══════════════════════════════════════════════════════════════╝");
            System.out.print("\n👉 Enter your choice: ");
            
            int choice;
            try {
                choice = Integer.parseInt(scanner.nextLine().trim());
            } catch (NumberFormatException e) {
                System.out.println("❌ Invalid input. Please enter a number.");
                continue;
            }
            
            switch (choice) {
                case 0:
                    System.out.println("\n👋 Thank you for learning about graphs! Goodbye!");
                    return;
                case 1:
                    addUserInteractive();
                    break;
                case 2:
                    addFriendshipInteractive();
                    break;
                case 3:
                    removeFriendshipInteractive();
                    break;
                case 4:
                    viewFriendsInteractive();
                    break;
                case 5:
                    findMutualFriendsInteractive();
                    break;
                case 6:
                    bfsInteractive();
                    break;
                case 7:
                    dfsInteractive();
                    break;
                case 8:
                    shortestPathInteractive();
                    break;
                case 9:
                    friendSuggestionsInteractive();
                    break;
                case 10:
                    network.findInfluencers(5);
                    break;
                case 11:
                    network.detectCommunities();
                    break;
                case 12:
                    network.printNetworkStats();
                    break;
                case 13:
                    exportVisualizationData();
                    System.out.println("✅ Data exported! Open 'visualization.html' in browser.");
                    break;
                case 14:
                    showEducationalContent();
                    break;
                default:
                    System.out.println("❌ Invalid choice. Please try again.");
            }
        }
    }
    
    private static void addUserInteractive() {
        System.out.print("Enter username: ");
        String username = scanner.nextLine().trim().toLowerCase();
        System.out.print("Enter full name: ");
        String name = scanner.nextLine().trim();
        System.out.print("Enter age: ");
        int age;
        try {
            age = Integer.parseInt(scanner.nextLine().trim());
        } catch (NumberFormatException e) {
            age = 0;
        }
        network.addUser(username, name, age);
        exportVisualizationData();
    }
    
    private static void addFriendshipInteractive() {
        System.out.println("Current users: " + network.getAllUsers());
        System.out.print("Enter first username: ");
        String user1 = scanner.nextLine().trim().toLowerCase();
        System.out.print("Enter second username: ");
        String user2 = scanner.nextLine().trim().toLowerCase();
        network.addFriendship(user1, user2);
        exportVisualizationData();
    }
    
    private static void removeFriendshipInteractive() {
        System.out.print("Enter first username: ");
        String user1 = scanner.nextLine().trim().toLowerCase();
        System.out.print("Enter second username: ");
        String user2 = scanner.nextLine().trim().toLowerCase();
        network.removeFriendship(user1, user2);
        exportVisualizationData();
    }
    
    private static void viewFriendsInteractive() {
        System.out.println("Current users: " + network.getAllUsers());
        System.out.print("Enter username: ");
        String username = scanner.nextLine().trim().toLowerCase();
        Set<String> friends = network.getFriends(username);
        System.out.println("👥 " + username + "'s friends: " + friends);
        System.out.println("   Total friends: " + friends.size());
    }
    
    private static void findMutualFriendsInteractive() {
        System.out.print("Enter first username: ");
        String user1 = scanner.nextLine().trim().toLowerCase();
        System.out.print("Enter second username: ");
        String user2 = scanner.nextLine().trim().toLowerCase();
        network.getMutualFriends(user1, user2);
    }
    
    private static void bfsInteractive() {
        System.out.println("\n📚 BFS (Breadth-First Search) Explanation:");
        System.out.println("   BFS explores the graph LEVEL BY LEVEL");
        System.out.println("   Level 0: Starting user");
        System.out.println("   Level 1: Direct friends");
        System.out.println("   Level 2: Friends of friends");
        System.out.println("   And so on...\n");
        
        System.out.println("Current users: " + network.getAllUsers());
        System.out.print("Enter starting username: ");
        String username = scanner.nextLine().trim().toLowerCase();
        network.bfs(username);
    }
    
    private static void dfsInteractive() {
        System.out.println("\n📚 DFS (Depth-First Search) Explanation:");
        System.out.println("   DFS explores as DEEP as possible before backtracking");
        System.out.println("   It follows one path to the end, then backtracks\n");
        
        System.out.println("Current users: " + network.getAllUsers());
        System.out.print("Enter starting username: ");
        String username = scanner.nextLine().trim().toLowerCase();
        network.dfs(username);
    }
    
    private static void shortestPathInteractive() {
        System.out.println("\n📚 Shortest Path = Degrees of Separation");
        System.out.println("   How many 'hops' to reach from one person to another?\n");
        
        System.out.println("Current users: " + network.getAllUsers());
        System.out.print("Enter start username: ");
        String start = scanner.nextLine().trim().toLowerCase();
        System.out.print("Enter end username: ");
        String end = scanner.nextLine().trim().toLowerCase();
        network.findShortestPath(start, end);
    }
    
    private static void friendSuggestionsInteractive() {
        System.out.println("\n📚 Friend Suggestions Algorithm:");
        System.out.println("   Looks at friends of your friends");
        System.out.println("   Ranks by number of mutual connections\n");
        
        System.out.println("Current users: " + network.getAllUsers());
        System.out.print("Enter username: ");
        String username = scanner.nextLine().trim().toLowerCase();
        network.suggestFriends(username);
    }
    
    /**
     * Educational content about graphs
     */
    private static void showEducationalContent() {
        System.out.println("\n╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║           📖 GRAPHS IN SOCIAL MEDIA - EXPLAINED              ║");
        System.out.println("╚══════════════════════════════════════════════════════════════╝");
        
        System.out.println("\n🔵 WHAT IS A GRAPH?");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("A graph is a data structure with:");
        System.out.println("  • NODES (Vertices) - Represent entities (users)");
        System.out.println("  • EDGES - Represent relationships (friendships)");
        System.out.println();
        System.out.println("Example:");
        System.out.println("    Alice -------- Bob");
        System.out.println("      |             |");
        System.out.println("      |             |");
        System.out.println("    Diana ------- Charlie");
        System.out.println();
        
        System.out.println("\n🔵 TYPES OF GRAPHS IN SOCIAL MEDIA:");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("1. UNDIRECTED GRAPH (Facebook, LinkedIn)");
        System.out.println("   - If A is friends with B, B is also friends with A");
        System.out.println("   - Mutual connection required");
        System.out.println();
        System.out.println("2. DIRECTED GRAPH (Twitter, Instagram followers)");
        System.out.println("   - A can follow B without B following A");
        System.out.println("   - One-way relationship possible");
        System.out.println();
        
        System.out.println("\n🔵 HOW SOCIAL MEDIA STORES CONNECTIONS:");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("ADJACENCY LIST (Most Common):");
        System.out.println("┌─────────┬──────────────────────────┐");
        System.out.println("│  User   │  Friends List            │");
        System.out.println("├─────────┼──────────────────────────┤");
        System.out.println("│  Alice  │  [Bob, Charlie, Diana]   │");
        System.out.println("│  Bob    │  [Alice, Charlie, Eve]   │");
        System.out.println("│  Charlie│  [Alice, Bob, Frank]     │");
        System.out.println("└─────────┴──────────────────────────┘");
        System.out.println();
        System.out.println("Why Adjacency List?");
        System.out.println("  ✓ Space efficient: O(V + E)");
        System.out.println("  ✓ Fast friend lookup: O(1) with HashSet");
        System.out.println("  ✓ Easy to add/remove connections");
        System.out.println();
        
        System.out.println("\n🔵 COMMON GRAPH ALGORITHMS:");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("1. BFS (Breadth-First Search)");
        System.out.println("   Use: Finding shortest path, friend suggestions");
        System.out.println("   How: Explores level by level (like ripples)");
        System.out.println();
        System.out.println("2. DFS (Depth-First Search)");
        System.out.println("   Use: Finding connected components, detecting cycles");
        System.out.println("   How: Goes deep first, then backtracks");
        System.out.println();
        System.out.println("3. Dijkstra's Algorithm");
        System.out.println("   Use: Finding weighted shortest paths");
        System.out.println("   How: Always picks the smallest distance first");
        System.out.println();
        
        System.out.println("\n🔵 REAL-WORLD APPLICATIONS:");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("• 'People You May Know' - Friends of friends (BFS)");
        System.out.println("• '6 Degrees of Separation' - Shortest path");
        System.out.println("• 'Mutual Friends' - Set intersection");
        System.out.println("• 'Trending Topics' - Influence propagation");
        System.out.println("• 'Community Detection' - Clustering algorithms");
        System.out.println("• 'News Feed Ranking' - PageRank-like algorithms");
        System.out.println();
        
        System.out.print("\nPress Enter to continue...");
        scanner.nextLine();
    }
    
    /**
     * Export graph data for HTML visualization
     */
    private static void exportVisualizationData() {
        try {
            String json = network.exportToJson();
            
            // Get the parent directory of src
            String basePath = new File("").getAbsolutePath();
            String filePath = basePath + File.separator + "graph_data.json";
            
            try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
                writer.println(json);
            }
            
            System.out.println("📁 Graph data exported to: " + filePath);
            
        } catch (IOException e) {
            System.out.println("❌ Error exporting data: " + e.getMessage());
        }
    }
}
