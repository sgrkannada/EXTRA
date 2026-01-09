import java.util.*;

/**
 * Social Network Graph Implementation
 * This class demonstrates how social media platforms use graphs to represent user connections
 * 
 * KEY CONCEPTS:
 * - Each user is a NODE (vertex) in the graph
 * - Each friendship/connection is an EDGE between nodes
 * - We use an ADJACENCY LIST to store connections efficiently
 */
public class SocialNetworkGraph {
    
    // Adjacency List - Maps each user to their list of friends/connections
    // This is how Facebook, Instagram, LinkedIn store your connections!
    private Map<String, Set<String>> adjacencyList;
    
    // Store user profiles (additional data about each node)
    private Map<String, UserProfile> userProfiles;
    
    /**
     * Constructor - Initialize empty graph
     */
    public SocialNetworkGraph() {
        this.adjacencyList = new HashMap<>();
        this.userProfiles = new HashMap<>();
        System.out.println("📊 Created new Social Network Graph!");
    }
    
    /**
     * ADD USER - Adding a new node to the graph
     * Time Complexity: O(1)
     * 
     * When you create a new account on social media, this is what happens!
     */
    public boolean addUser(String username, String name, int age) {
        if (adjacencyList.containsKey(username)) {
            System.out.println("❌ User '" + username + "' already exists!");
            return false;
        }
        
        // Add new node with empty connections
        adjacencyList.put(username, new HashSet<>());
        userProfiles.put(username, new UserProfile(username, name, age));
        
        System.out.println("✅ Added user: " + username + " (" + name + ")");
        return true;
    }
    
    /**
     * ADD FRIENDSHIP - Adding an edge between two nodes
     * This is an UNDIRECTED graph (if A is friends with B, then B is friends with A)
     * Time Complexity: O(1)
     * 
     * This happens when you send/accept a friend request!
     */
    public boolean addFriendship(String user1, String user2) {
        if (!adjacencyList.containsKey(user1) || !adjacencyList.containsKey(user2)) {
            System.out.println("❌ One or both users don't exist!");
            return false;
        }
        
        if (user1.equals(user2)) {
            System.out.println("❌ Cannot be friends with yourself!");
            return false;
        }
        
        // Add bidirectional edge (undirected graph)
        adjacencyList.get(user1).add(user2);
        adjacencyList.get(user2).add(user1);
        
        System.out.println("🤝 " + user1 + " and " + user2 + " are now friends!");
        return true;
    }
    
    /**
     * REMOVE FRIENDSHIP - Removing an edge
     * Time Complexity: O(1)
     * 
     * This is the "Unfriend" feature!
     */
    public boolean removeFriendship(String user1, String user2) {
        if (!adjacencyList.containsKey(user1) || !adjacencyList.containsKey(user2)) {
            return false;
        }
        
        adjacencyList.get(user1).remove(user2);
        adjacencyList.get(user2).remove(user1);
        
        System.out.println("💔 " + user1 + " and " + user2 + " are no longer friends.");
        return true;
    }
    
    /**
     * GET FRIENDS - Get all direct connections of a user
     * Time Complexity: O(1)
     * 
     * This is your "Friends List"!
     */
    public Set<String> getFriends(String username) {
        if (!adjacencyList.containsKey(username)) {
            return new HashSet<>();
        }
        return new HashSet<>(adjacencyList.get(username));
    }
    
    /**
     * CHECK FRIENDSHIP - Check if two users are directly connected
     * Time Complexity: O(1)
     * 
     * "Are these two people friends?"
     */
    public boolean areFriends(String user1, String user2) {
        if (!adjacencyList.containsKey(user1)) {
            return false;
        }
        return adjacencyList.get(user1).contains(user2);
    }
    
    /**
     * MUTUAL FRIENDS - Find common friends between two users
     * Time Complexity: O(min(n, m)) where n, m are friend counts
     * 
     * Facebook's "Mutual Friends" feature!
     */
    public Set<String> getMutualFriends(String user1, String user2) {
        Set<String> mutual = new HashSet<>();
        
        if (!adjacencyList.containsKey(user1) || !adjacencyList.containsKey(user2)) {
            return mutual;
        }
        
        Set<String> friends1 = adjacencyList.get(user1);
        Set<String> friends2 = adjacencyList.get(user2);
        
        // Find intersection of two sets
        for (String friend : friends1) {
            if (friends2.contains(friend)) {
                mutual.add(friend);
            }
        }
        
        System.out.println("👥 Mutual friends between " + user1 + " and " + user2 + ": " + mutual);
        return mutual;
    }
    
    /**
     * BFS - Breadth First Search
     * Used for: Finding shortest path, friend suggestions, "People you may know"
     * Time Complexity: O(V + E)
     * 
     * This explores the graph level by level (like ripples in water)
     */
    public List<String> bfs(String startUser) {
        List<String> visited = new ArrayList<>();
        
        if (!adjacencyList.containsKey(startUser)) {
            return visited;
        }
        
        Queue<String> queue = new LinkedList<>();
        Set<String> seen = new HashSet<>();
        
        queue.offer(startUser);
        seen.add(startUser);
        
        System.out.println("\n🔍 BFS Traversal starting from " + startUser + ":");
        System.out.println("Level 0: " + startUser);
        
        int level = 1;
        while (!queue.isEmpty()) {
            int levelSize = queue.size();
            List<String> currentLevel = new ArrayList<>();
            
            for (int i = 0; i < levelSize; i++) {
                String current = queue.poll();
                visited.add(current);
                
                for (String neighbor : adjacencyList.get(current)) {
                    if (!seen.contains(neighbor)) {
                        seen.add(neighbor);
                        queue.offer(neighbor);
                        currentLevel.add(neighbor);
                    }
                }
            }
            
            if (!currentLevel.isEmpty()) {
                System.out.println("Level " + level + ": " + currentLevel);
                level++;
            }
        }
        
        return visited;
    }
    
    /**
     * DFS - Depth First Search
     * Used for: Finding all connected components, detecting communities
     * Time Complexity: O(V + E)
     * 
     * This explores as deep as possible before backtracking
     */
    public List<String> dfs(String startUser) {
        List<String> visited = new ArrayList<>();
        
        if (!adjacencyList.containsKey(startUser)) {
            return visited;
        }
        
        Set<String> seen = new HashSet<>();
        System.out.println("\n🔍 DFS Traversal starting from " + startUser + ":");
        dfsHelper(startUser, seen, visited, 0);
        
        return visited;
    }
    
    private void dfsHelper(String user, Set<String> seen, List<String> visited, int depth) {
        seen.add(user);
        visited.add(user);
        
        String indent = "  ".repeat(depth);
        System.out.println(indent + "→ Visiting: " + user);
        
        for (String neighbor : adjacencyList.get(user)) {
            if (!seen.contains(neighbor)) {
                dfsHelper(neighbor, seen, visited, depth + 1);
            }
        }
    }
    
    /**
     * SHORTEST PATH - Find shortest connection path between two users
     * Uses BFS (unweighted shortest path)
     * 
     * "Degrees of separation" - How many people connect you to someone?
     */
    public List<String> findShortestPath(String start, String end) {
        if (!adjacencyList.containsKey(start) || !adjacencyList.containsKey(end)) {
            return new ArrayList<>();
        }
        
        if (start.equals(end)) {
            return Arrays.asList(start);
        }
        
        Queue<String> queue = new LinkedList<>();
        Map<String, String> parent = new HashMap<>();
        Set<String> visited = new HashSet<>();
        
        queue.offer(start);
        visited.add(start);
        parent.put(start, null);
        
        while (!queue.isEmpty()) {
            String current = queue.poll();
            
            if (current.equals(end)) {
                // Reconstruct path
                List<String> path = new ArrayList<>();
                String node = end;
                while (node != null) {
                    path.add(0, node);
                    node = parent.get(node);
                }
                
                System.out.println("\n🛤️ Shortest path from " + start + " to " + end + ":");
                System.out.println("   " + String.join(" → ", path));
                System.out.println("   Degrees of separation: " + (path.size() - 1));
                return path;
            }
            
            for (String neighbor : adjacencyList.get(current)) {
                if (!visited.contains(neighbor)) {
                    visited.add(neighbor);
                    parent.put(neighbor, current);
                    queue.offer(neighbor);
                }
            }
        }
        
        System.out.println("❌ No path exists between " + start + " and " + end);
        return new ArrayList<>();
    }
    
    /**
     * FRIEND SUGGESTIONS - People you may know
     * Suggests friends of friends who aren't already your friends
     * Time Complexity: O(F * F) where F is average friend count
     * 
     * This is how Facebook/LinkedIn suggest new connections!
     */
    public List<String> suggestFriends(String username) {
        List<String> suggestions = new ArrayList<>();
        
        if (!adjacencyList.containsKey(username)) {
            return suggestions;
        }
        
        Set<String> currentFriends = adjacencyList.get(username);
        Map<String, Integer> suggestionScore = new HashMap<>();
        
        // Look at friends of friends
        for (String friend : currentFriends) {
            for (String friendOfFriend : adjacencyList.get(friend)) {
                // Skip if it's the user themselves or already a friend
                if (!friendOfFriend.equals(username) && !currentFriends.contains(friendOfFriend)) {
                    // Score = number of mutual friends
                    suggestionScore.merge(friendOfFriend, 1, Integer::sum);
                }
            }
        }
        
        // Sort by score (most mutual friends first)
        suggestions = new ArrayList<>(suggestionScore.keySet());
        suggestions.sort((a, b) -> suggestionScore.get(b) - suggestionScore.get(a));
        
        System.out.println("\n💡 Friend suggestions for " + username + ":");
        for (String suggestion : suggestions) {
            System.out.println("   - " + suggestion + " (" + suggestionScore.get(suggestion) + " mutual friends)");
        }
        
        return suggestions;
    }
    
    /**
     * FIND INFLUENCERS - Users with most connections
     * Uses degree centrality (number of connections)
     */
    public List<String> findInfluencers(int topN) {
        List<Map.Entry<String, Integer>> users = new ArrayList<>();
        
        for (String user : adjacencyList.keySet()) {
            users.add(new AbstractMap.SimpleEntry<>(user, adjacencyList.get(user).size()));
        }
        
        users.sort((a, b) -> b.getValue() - a.getValue());
        
        List<String> influencers = new ArrayList<>();
        System.out.println("\n⭐ Top " + topN + " Influencers:");
        
        for (int i = 0; i < Math.min(topN, users.size()); i++) {
            Map.Entry<String, Integer> entry = users.get(i);
            influencers.add(entry.getKey());
            System.out.println("   " + (i + 1) + ". " + entry.getKey() + " - " + entry.getValue() + " connections");
        }
        
        return influencers;
    }
    
    /**
     * DETECT COMMUNITIES - Find groups of closely connected users
     * Simple implementation using connected components
     */
    public List<Set<String>> detectCommunities() {
        List<Set<String>> communities = new ArrayList<>();
        Set<String> visited = new HashSet<>();
        
        for (String user : adjacencyList.keySet()) {
            if (!visited.contains(user)) {
                Set<String> community = new HashSet<>();
                Queue<String> queue = new LinkedList<>();
                queue.offer(user);
                
                while (!queue.isEmpty()) {
                    String current = queue.poll();
                    if (visited.contains(current)) continue;
                    
                    visited.add(current);
                    community.add(current);
                    
                    for (String neighbor : adjacencyList.get(current)) {
                        if (!visited.contains(neighbor)) {
                            queue.offer(neighbor);
                        }
                    }
                }
                
                communities.add(community);
            }
        }
        
        System.out.println("\n🏘️ Detected " + communities.size() + " communities:");
        int i = 1;
        for (Set<String> community : communities) {
            System.out.println("   Community " + i++ + ": " + community);
        }
        
        return communities;
    }
    
    /**
     * GET NETWORK STATISTICS
     */
    public void printNetworkStats() {
        int totalUsers = adjacencyList.size();
        int totalEdges = 0;
        int maxConnections = 0;
        String mostPopular = "";
        
        for (Map.Entry<String, Set<String>> entry : adjacencyList.entrySet()) {
            int connections = entry.getValue().size();
            totalEdges += connections;
            if (connections > maxConnections) {
                maxConnections = connections;
                mostPopular = entry.getKey();
            }
        }
        totalEdges /= 2; // Each edge counted twice
        
        System.out.println("\n📈 Network Statistics:");
        System.out.println("   Total Users (Nodes): " + totalUsers);
        System.out.println("   Total Friendships (Edges): " + totalEdges);
        System.out.println("   Average Connections: " + (totalUsers > 0 ? String.format("%.2f", (double) totalEdges * 2 / totalUsers) : 0));
        System.out.println("   Most Popular User: " + mostPopular + " (" + maxConnections + " connections)");
    }
    
    /**
     * EXPORT TO JSON - For visualization
     */
    public String exportToJson() {
        StringBuilder json = new StringBuilder();
        json.append("{\n");
        
        // Export nodes
        json.append("  \"nodes\": [\n");
        List<String> users = new ArrayList<>(adjacencyList.keySet());
        for (int i = 0; i < users.size(); i++) {
            String user = users.get(i);
            UserProfile profile = userProfiles.get(user);
            json.append("    {\"id\": \"").append(user).append("\", \"name\": \"");
            json.append(profile != null ? profile.name : user).append("\", \"connections\": ");
            json.append(adjacencyList.get(user).size()).append("}");
            if (i < users.size() - 1) json.append(",");
            json.append("\n");
        }
        json.append("  ],\n");
        
        // Export edges
        json.append("  \"edges\": [\n");
        Set<String> processedEdges = new HashSet<>();
        boolean first = true;
        for (String user : adjacencyList.keySet()) {
            for (String friend : adjacencyList.get(user)) {
                String edgeKey = user.compareTo(friend) < 0 ? user + "-" + friend : friend + "-" + user;
                if (!processedEdges.contains(edgeKey)) {
                    if (!first) json.append(",\n");
                    json.append("    {\"source\": \"").append(user).append("\", \"target\": \"").append(friend).append("\"}");
                    processedEdges.add(edgeKey);
                    first = false;
                }
            }
        }
        json.append("\n  ]\n");
        json.append("}");
        
        return json.toString();
    }
    
    /**
     * Get all users
     */
    public Set<String> getAllUsers() {
        return new HashSet<>(adjacencyList.keySet());
    }
    
    /**
     * Inner class for User Profile
     */
    static class UserProfile {
        String username;
        String name;
        int age;
        
        UserProfile(String username, String name, int age) {
            this.username = username;
            this.name = name;
            this.age = age;
        }
    }
}
