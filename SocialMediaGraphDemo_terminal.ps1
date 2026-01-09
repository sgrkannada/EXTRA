# ============================================================================
# SOCIAL MEDIA GRAPH LEARNING TOOL
# An Interactive Educational Demo for Understanding Graph Data Structures
# ============================================================================

# Clear the console for a fresh start
Clear-Host

# ============================================================================
# SECTION 1: GRAPH DATA STRUCTURE SETUP
# ============================================================================

# Global variables to store our social network graph
$script:Users = @{}          # Adjacency List representation of the graph
$script:UserProfiles = @{}   # Store user profile information
$script:Posts = @{}          # Store user posts
$script:MessageHistory = @() # Store interaction history

# Color scheme for visual appeal
$script:Colors = @{
    Title = "Cyan"
    Success = "Green"
    Error = "Red"
    Info = "Yellow"
    Highlight = "Magenta"
    Normal = "White"
    Graph = "DarkCyan"
}

# ============================================================================
# SECTION 2: HELPER FUNCTIONS
# ============================================================================

function Write-Colored {
    param(
        [string]$Text,
        [string]$Color = "White",
        [switch]$NoNewLine
    )
    if ($NoNewLine) {
        Write-Host $Text -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Text -ForegroundColor $Color
    }
}

function Write-Banner {
    param([string]$Text)
    $border = "=" * 70
    Write-Host ""
    Write-Colored $border "Cyan"
    Write-Colored "  $Text" "Yellow"
    Write-Colored $border "Cyan"
    Write-Host ""
}

function Write-SubBanner {
    param([string]$Text)
    $border = "-" * 50
    Write-Colored $border "DarkCyan"
    Write-Colored "  $Text" "Cyan"
    Write-Colored $border "DarkCyan"
}

function Pause-WithMessage {
    param([string]$Message = "Press Enter to continue...")
    Write-Host ""
    Write-Colored $Message "DarkGray"
    Read-Host
}

# ============================================================================
# SECTION 3: GRAPH OPERATIONS - THE CORE LEARNING CONTENT
# ============================================================================

function Add-User {
    <#
    .SYNOPSIS
    Adds a new user (vertex/node) to our social network graph.
    
    .DESCRIPTION
    In graph terms, this creates a new VERTEX (node).
    Each user is a node in our social network graph.
    The adjacency list for this node starts empty.
    #>
    param(
        [string]$Username,
        [string]$FullName,
        [int]$Age,
        [string]$Location
    )
    
    if ($script:Users.ContainsKey($Username)) {
        Write-Colored "User '$Username' already exists!" "Red"
        return $false
    }
    
    # Create the node in our adjacency list (empty connections)
    $script:Users[$Username] = @()
    
    # Store profile information
    $script:UserProfiles[$Username] = @{
        FullName = $FullName
        Age = $Age
        Location = $Location
        JoinDate = Get-Date
    }
    
    $script:Posts[$Username] = @()
    
    return $true
}

function Add-Friendship {
    <#
    .SYNOPSIS
    Creates a friendship connection (edge) between two users.
    
    .DESCRIPTION
    In graph terms, this creates an EDGE between two vertices.
    Social media friendships are typically UNDIRECTED edges
    (if A is friends with B, then B is friends with A).
    
    This is different from "following" which would be a DIRECTED edge.
    #>
    param(
        [string]$User1,
        [string]$User2
    )
    
    if (-not $script:Users.ContainsKey($User1)) {
        Write-Colored "User '$User1' doesn't exist!" "Red"
        return $false
    }
    if (-not $script:Users.ContainsKey($User2)) {
        Write-Colored "User '$User2' doesn't exist!" "Red"
        return $false
    }
    
    # Check if already friends
    if ($script:Users[$User1] -contains $User2) {
        Write-Colored "They are already friends!" "Yellow"
        return $false
    }
    
    # Add UNDIRECTED edge (both directions for friendship)
    $script:Users[$User1] += $User2
    $script:Users[$User2] += $User1
    
    return $true
}

function Get-Friends {
    <#
    .SYNOPSIS
    Gets all friends (adjacent vertices) of a user.
    
    .DESCRIPTION
    Returns all vertices connected to the given vertex by an edge.
    In adjacency list representation, this is O(1) to access the list.
    #>
    param([string]$Username)
    
    if (-not $script:Users.ContainsKey($Username)) {
        return @()
    }
    return $script:Users[$Username]
}

function Get-MutualFriends {
    <#
    .SYNOPSIS
    Finds mutual friends between two users.
    
    .DESCRIPTION
    This finds the INTERSECTION of two adjacency lists.
    Mutual friends are vertices that have edges to BOTH given vertices.
    Time complexity: O(min(n,m)) where n,m are friend counts.
    #>
    param(
        [string]$User1,
        [string]$User2
    )
    
    $friends1 = Get-Friends -Username $User1
    $friends2 = Get-Friends -Username $User2
    
    $mutual = @()
    foreach ($friend in $friends1) {
        if ($friends2 -contains $friend) {
            $mutual += $friend
        }
    }
    return $mutual
}

# ============================================================================
# SECTION 4: GRAPH TRAVERSAL ALGORITHMS
# ============================================================================

function Search-BFS {
    <#
    .SYNOPSIS
    Breadth-First Search - Finds shortest path between users.
    
    .DESCRIPTION
    BFS explores the graph level by level using a QUEUE.
    Perfect for finding the shortest path (degrees of separation).
    
    How it works:
    1. Start from source vertex
    2. Visit all neighbors (level 1)
    3. Then visit all neighbors of neighbors (level 2)
    4. Continue until target is found
    
    Time Complexity: O(V + E) where V = vertices, E = edges
    Space Complexity: O(V) for the visited set and queue
    #>
    param(
        [string]$StartUser,
        [string]$TargetUser,
        [switch]$Visualize
    )
    
    if (-not $script:Users.ContainsKey($StartUser) -or -not $script:Users.ContainsKey($TargetUser)) {
        Write-Colored "One or both users don't exist!" "Red"
        return $null
    }
    
    if ($StartUser -eq $TargetUser) {
        return @($StartUser)
    }
    
    # BFS uses a QUEUE (First-In-First-Out)
    $queue = New-Object System.Collections.Queue
    $visited = @{}
    $parent = @{}
    
    $queue.Enqueue($StartUser)
    $visited[$StartUser] = $true
    $parent[$StartUser] = $null
    
    $level = 0
    $nodesAtCurrentLevel = 1
    $nodesAtNextLevel = 0
    
    if ($Visualize) {
        Write-Colored "`n  BFS TRAVERSAL VISUALIZATION" "Cyan"
        Write-Colored "  Starting from: $StartUser" "Yellow"
        Write-Colored "  Looking for: $TargetUser`n" "Yellow"
    }
    
    while ($queue.Count -gt 0) {
        $current = $queue.Dequeue()
        $nodesAtCurrentLevel--
        
        if ($Visualize) {
            Write-Colored "  Level $level - Visiting: " "DarkCyan" -NoNewLine
            Write-Colored $current "White"
        }
        
        # Check if we found the target
        if ($current -eq $TargetUser) {
            # Reconstruct path
            $path = @()
            $node = $TargetUser
            while ($node -ne $null) {
                $path = @($node) + $path
                $node = $parent[$node]
            }
            
            if ($Visualize) {
                Write-Colored "  TARGET FOUND!" "Green"
            }
            return $path
        }
        
        # Explore neighbors
        foreach ($neighbor in $script:Users[$current]) {
            if (-not $visited.ContainsKey($neighbor)) {
                $visited[$neighbor] = $true
                $parent[$neighbor] = $current
                $queue.Enqueue($neighbor)
                $nodesAtNextLevel++
                
                if ($Visualize) {
                    Write-Colored "    -> Adding to queue: $neighbor" "DarkGray"
                }
            }
        }
        
        # Track levels for visualization
        if ($nodesAtCurrentLevel -eq 0) {
            $level++
            $nodesAtCurrentLevel = $nodesAtNextLevel
            $nodesAtNextLevel = 0
        }
    }
    
    return $null  # No path found
}

function Search-DFS {
    <#
    .SYNOPSIS
    Depth-First Search - Explores paths deeply before backtracking.
    
    .DESCRIPTION
    DFS explores as far as possible along each branch using a STACK.
    Useful for finding if a path exists, exploring all connections.
    
    How it works:
    1. Start from source vertex
    2. Go as deep as possible along one path
    3. Backtrack when no more unvisited neighbors
    4. Continue until all reachable vertices visited
    
    Time Complexity: O(V + E)
    Space Complexity: O(V) for the visited set and stack
    #>
    param(
        [string]$StartUser,
        [string]$TargetUser = $null,
        [switch]$Visualize
    )
    
    if (-not $script:Users.ContainsKey($StartUser)) {
        Write-Colored "User '$StartUser' doesn't exist!" "Red"
        return @()
    }
    
    # DFS uses a STACK (Last-In-First-Out)
    $stack = New-Object System.Collections.Stack
    $visited = @{}
    $visitOrder = @()
    
    $stack.Push($StartUser)
    
    if ($Visualize) {
        Write-Colored "`n  DFS TRAVERSAL VISUALIZATION" "Cyan"
        Write-Colored "  Starting from: $StartUser`n" "Yellow"
    }
    
    while ($stack.Count -gt 0) {
        $current = $stack.Pop()
        
        if ($visited.ContainsKey($current)) {
            continue
        }
        
        $visited[$current] = $true
        $visitOrder += $current
        
        if ($Visualize) {
            $depth = "  " * ($visitOrder.Count)
            Write-Colored "$depth Visiting: $current" "White"
        }
        
        if ($TargetUser -and $current -eq $TargetUser) {
            if ($Visualize) {
                Write-Colored "  TARGET FOUND!" "Green"
            }
            return $visitOrder
        }
        
        # Add neighbors to stack (reverse order for consistent traversal)
        $neighbors = $script:Users[$current]
        for ($i = $neighbors.Count - 1; $i -ge 0; $i--) {
            if (-not $visited.ContainsKey($neighbors[$i])) {
                $stack.Push($neighbors[$i])
                if ($Visualize) {
                    Write-Colored "$depth   -> Pushing: $($neighbors[$i])" "DarkGray"
                }
            }
        }
    }
    
    return $visitOrder
}

function Get-DegreesOfSeparation {
    <#
    .SYNOPSIS
    Calculates the "Six Degrees of Separation" between users.
    
    .DESCRIPTION
    Uses BFS to find the shortest path length between two users.
    This is a classic social network metric - how many "hops"
    separate any two people in the network.
    #>
    param(
        [string]$User1,
        [string]$User2
    )
    
    $path = Search-BFS -StartUser $User1 -TargetUser $User2
    
    if ($path -eq $null) {
        return -1  # Not connected
    }
    
    return $path.Count - 1  # Degrees = edges, not vertices
}

# ============================================================================
# SECTION 5: FRIEND RECOMMENDATION ALGORITHM
# ============================================================================

function Get-FriendRecommendations {
    <#
    .SYNOPSIS
    Recommends friends using "Friends of Friends" algorithm.
    
    .DESCRIPTION
    This is how social media platforms recommend new connections!
    
    Algorithm:
    1. Find all friends of user (1-hop neighbors)
    2. Find all friends of friends (2-hop neighbors)
    3. Count how many mutual connections each potential friend has
    4. Rank by mutual friend count
    5. Filter out existing friends and the user themselves
    
    This is essentially counting paths of length 2 between users.
    #>
    param(
        [string]$Username,
        [int]$TopN = 5
    )
    
    if (-not $script:Users.ContainsKey($Username)) {
        return @()
    }
    
    $directFriends = Get-Friends -Username $Username
    $recommendations = @{}
    
    # For each friend, look at their friends
    foreach ($friend in $directFriends) {
        $friendsOfFriend = Get-Friends -Username $friend
        
        foreach ($potentialFriend in $friendsOfFriend) {
            # Skip if it's the user themselves or already a friend
            if ($potentialFriend -eq $Username) { continue }
            if ($directFriends -contains $potentialFriend) { continue }
            
            # Count this as a mutual connection
            if ($recommendations.ContainsKey($potentialFriend)) {
                $recommendations[$potentialFriend]++
            } else {
                $recommendations[$potentialFriend] = 1
            }
        }
    }
    
    # Sort by mutual friend count and return top N
    $sorted = $recommendations.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First $TopN
    return $sorted
}

# ============================================================================
# SECTION 6: GRAPH ANALYSIS FUNCTIONS
# ============================================================================

function Get-NetworkStatistics {
    <#
    .SYNOPSIS
    Calculates various graph metrics for the social network.
    #>
    
    $totalUsers = $script:Users.Count
    $totalEdges = 0
    $maxDegree = 0
    $maxDegreeUser = ""
    $totalDegree = 0
    
    foreach ($user in $script:Users.Keys) {
        $degree = $script:Users[$user].Count
        $totalEdges += $degree
        $totalDegree += $degree
        
        if ($degree -gt $maxDegree) {
            $maxDegree = $degree
            $maxDegreeUser = $user
        }
    }
    
    # Each edge is counted twice in undirected graph
    $totalEdges = $totalEdges / 2
    
    $avgDegree = if ($totalUsers -gt 0) { $totalDegree / $totalUsers } else { 0 }
    
    # Calculate density: actual edges / possible edges
    $possibleEdges = if ($totalUsers -gt 1) { ($totalUsers * ($totalUsers - 1)) / 2 } else { 0 }
    $density = if ($possibleEdges -gt 0) { $totalEdges / $possibleEdges } else { 0 }
    
    return @{
        TotalUsers = $totalUsers
        TotalConnections = $totalEdges
        AverageFriends = [math]::Round($avgDegree, 2)
        MostConnectedUser = $maxDegreeUser
        MostConnections = $maxDegree
        NetworkDensity = [math]::Round($density, 4)
    }
}

function Find-ConnectedComponents {
    <#
    .SYNOPSIS
    Finds all isolated groups in the network.
    
    .DESCRIPTION
    A connected component is a subgraph where any two vertices
    are connected by a path. This finds all such groups.
    #>
    
    $visited = @{}
    $components = @()
    
    foreach ($user in $script:Users.Keys) {
        if (-not $visited.ContainsKey($user)) {
            # BFS to find all users in this component
            $component = @()
            $queue = New-Object System.Collections.Queue
            $queue.Enqueue($user)
            $visited[$user] = $true
            
            while ($queue.Count -gt 0) {
                $current = $queue.Dequeue()
                $component += $current
                
                foreach ($neighbor in $script:Users[$current]) {
                    if (-not $visited.ContainsKey($neighbor)) {
                        $visited[$neighbor] = $true
                        $queue.Enqueue($neighbor)
                    }
                }
            }
            
            $components += ,@($component)
        }
    }
    
    return $components
}

function Get-Influencers {
    <#
    .SYNOPSIS
    Identifies the most influential users (highest degree centrality).
    
    .DESCRIPTION
    Degree centrality is the simplest measure of importance in a network.
    Users with more connections have higher influence potential.
    #>
    param([int]$TopN = 5)
    
    $centrality = @{}
    
    foreach ($user in $script:Users.Keys) {
        $centrality[$user] = $script:Users[$user].Count
    }
    
    return $centrality.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First $TopN
}

# ============================================================================
# SECTION 7: VISUALIZATION FUNCTIONS
# ============================================================================

function Show-GraphVisualization {
    <#
    .SYNOPSIS
    Displays a text-based visualization of the social network graph.
    #>
    
    Write-Banner "SOCIAL NETWORK GRAPH VISUALIZATION"
    
    Write-Colored "`n  ADJACENCY LIST REPRESENTATION:`n" "Yellow"
    
    foreach ($user in $script:Users.Keys | Sort-Object) {
        $friends = $script:Users[$user] -join ", "
        if ($friends -eq "") { $friends = "(no connections)" }
        
        Write-Colored "  [$user]" "Cyan" -NoNewLine
        Write-Colored " --> " "DarkGray" -NoNewLine
        Write-Colored $friends "White"
    }
    
    Write-Host "`n"
    Write-Colored "  NETWORK HUB VIEW (Central Node Structure):`n" "Yellow"
    
    # Find most connected user
    $mostConnected = ""
    $maxFriends = 0
    foreach ($user in $script:Users.Keys) {
        if ($script:Users[$user].Count -gt $maxFriends) {
            $maxFriends = $script:Users[$user].Count
            $mostConnected = $user
        }
    }
    
    Write-Host ""
    Write-Colored "                          +----------HUB----------+" "Green"
    Write-Colored "                          |   $($mostConnected.ToUpper())       |" "Green"
    Write-Colored "                          +----------------------+" "Green"
    Write-Host ""
    Write-Colored "         +--------+--------+--------+--------+--------+--------+" "DarkCyan"
    Write-Host ""
    
    $hubFriends = $script:Users[$mostConnected]
    $mid = [math]::Floor($hubFriends.Count / 2)
    
    # Draw left side
    for ($i = 0; $i -lt $mid; $i++) {
        $friend = $hubFriends[$i]
        $deg = $script:Users[$friend].Count
        $color = if ($deg -gt 3) { "Magenta" } else { "White" }
        Write-Colored "  +-------+   " "DarkCyan" -NoNewLine
        Write-Colored $friend "$color"
    }
    
    Write-Host ""
    Write-Colored "         +--------+--------+--------+--------+--------+--------+" "DarkCyan"
    Write-Host ""
    
    # Draw right side
    for ($i = $mid; $i -lt $hubFriends.Count; $i++) {
        $friend = $hubFriends[$i]
        $deg = $script:Users[$friend].Count
        $color = if ($deg -gt 3) { "Magenta" } else { "White" }
        Write-Colored "                                  +-------+   " "DarkCyan" -NoNewLine
        Write-Colored $friend "$color"
    }
    
    Write-Host ""
    Write-Colored "  DETAILED CONNECTION MAP:`n" "Yellow"
    
    foreach ($user in $script:Users.Keys | Sort-Object) {
        $degree = $script:Users[$user].Count
        $degreeColor = switch ($degree) {
            {$_ -ge 5} { "Magenta" }
            {$_ -ge 3} { "Green" }
            default { "White" }
        }
        
        Write-Colored "  " "White" -NoNewLine
        Write-Colored "*" "Cyan" -NoNewLine
        Write-Colored " $user" "Cyan" -NoNewLine
        Write-Colored " (" "DarkGray" -NoNewLine
        Write-Colored "$degree friends" $degreeColor -NoNewLine
        Write-Colored "): " "DarkGray" -NoNewLine
        
        $friends = $script:Users[$user]
        if ($friends.Count -gt 0) {
            Write-Colored ($friends -join ", ") "White"
        } else {
            Write-Colored "(no connections)" "Red"
        }
    }
}

function Show-AdjacencyMatrix {
    <#
    .SYNOPSIS
    Displays the adjacency matrix representation of the graph.
    
    .DESCRIPTION
    An adjacency matrix is a 2D array where matrix[i][j] = 1
    if there's an edge between vertex i and vertex j.
    
    Pros: O(1) edge lookup
    Cons: O(V²) space, even for sparse graphs
    #>
    
    Write-Banner "ADJACENCY MATRIX REPRESENTATION"
    
    $users = @($script:Users.Keys | Sort-Object)
    $n = $users.Count
    
    if ($n -eq 0) {
        Write-Colored "No users in the network!" "Yellow"
        return
    }
    
    if ($n -gt 10) {
        Write-Colored "Matrix too large to display nicely. Showing first 10 users." "Yellow"
        $users = $users[0..9]
        $n = 10
    }
    
    # Header
    Write-Host ""
    Write-Colored "           " "White" -NoNewLine
    foreach ($user in $users) {
        $short = $user.Substring(0, [Math]::Min(3, $user.Length)).PadRight(4)
        Write-Colored $short "Cyan" -NoNewLine
    }
    Write-Host ""
    Write-Colored "          +" "DarkGray" -NoNewLine
    Write-Colored ("-" * ($n * 4)) "DarkGray"
    
    # Rows
    foreach ($user1 in $users) {
        $short1 = $user1.Substring(0, [Math]::Min(8, $user1.Length)).PadRight(8)
        Write-Colored "  $short1 |" "Cyan" -NoNewLine
        
        foreach ($user2 in $users) {
            if ($script:Users[$user1] -contains $user2) {
                Write-Colored "  1 " "Green" -NoNewLine
            } else {
                Write-Colored "  0 " "DarkGray" -NoNewLine
            }
        }
        Write-Host ""
    }
    
    Write-Host ""
    Write-Colored "  Legend: 1 = Connected (Friends), 0 = Not Connected" "Yellow"
}

# ============================================================================
# SECTION 8: INTERACTIVE DEMO AND LESSONS
# ============================================================================

function Initialize-SampleNetwork {
    <#
    .SYNOPSIS
    Creates a sample social network for demonstration.
    #>
    
    # Clear existing data
    $script:Users = @{}
    $script:UserProfiles = @{}
    $script:Posts = @{}
    
    # Add sample users (vertices)
    $sampleUsers = @(
        @{Username="alice"; FullName="Alice Johnson"; Age=25; Location="New York"},
        @{Username="bob"; FullName="Bob Smith"; Age=28; Location="Los Angeles"},
        @{Username="charlie"; FullName="Charlie Brown"; Age=22; Location="Chicago"},
        @{Username="diana"; FullName="Diana Ross"; Age=30; Location="Miami"},
        @{Username="eve"; FullName="Eve Williams"; Age=26; Location="Seattle"},
        @{Username="frank"; FullName="Frank Miller"; Age=35; Location="Boston"},
        @{Username="grace"; FullName="Grace Lee"; Age=24; Location="San Francisco"},
        @{Username="henry"; FullName="Henry Davis"; Age=29; Location="Denver"},
        @{Username="ivy"; FullName="Ivy Chen"; Age=27; Location="Austin"},
        @{Username="jack"; FullName="Jack Wilson"; Age=31; Location="Portland"}
    )
    
    foreach ($user in $sampleUsers) {
        Add-User -Username $user.Username -FullName $user.FullName -Age $user.Age -Location $user.Location | Out-Null
    }
    
    # Add friendships (edges) - creating a realistic social network
    $friendships = @(
        @("alice", "bob"),
        @("alice", "charlie"),
        @("alice", "diana"),
        @("bob", "charlie"),
        @("bob", "eve"),
        @("charlie", "diana"),
        @("charlie", "frank"),
        @("diana", "eve"),
        @("eve", "frank"),
        @("eve", "grace"),
        @("frank", "grace"),
        @("grace", "henry"),
        @("henry", "ivy"),
        @("ivy", "jack"),
        @("bob", "henry"),
        @("alice", "grace")
    )
    
    foreach ($friendship in $friendships) {
        Add-Friendship -User1 $friendship[0] -User2 $friendship[1] | Out-Null
    }
}

function Show-Lesson {
    param([int]$LessonNumber)
    
    switch ($LessonNumber) {
        1 {
            Write-Banner "LESSON 1: WHAT IS A GRAPH?"
            
            Write-Colored @"

  A GRAPH is a data structure consisting of:
  
  • VERTICES (Nodes): The entities in our network
    In social media: Each USER is a vertex
    
  • EDGES (Connections): The relationships between entities
    In social media: Each FRIENDSHIP is an edge
    
  TYPES OF GRAPHS:
  
  1. UNDIRECTED GRAPH - Edges have no direction
     Example: Facebook friendships (if A is friends with B, B is friends with A)
     
     Alice -------- Bob
     
  2. DIRECTED GRAPH - Edges have direction
     Example: Twitter follows (A can follow B without B following A)
     
     Alice ------> Bob  (Alice follows Bob)
     
  3. WEIGHTED GRAPH - Edges have values/weights
     Example: Interaction frequency, relationship strength
     
     Alice ---5--- Bob  (interacted 5 times)

"@ "White"
            
            Write-Colored "  Let's see our social network graph!" "Yellow"
            Pause-WithMessage
            Show-GraphVisualization
        }
        
        2 {
            Write-Banner "LESSON 2: GRAPH REPRESENTATIONS"
            
            Write-Colored @"

  There are two main ways to represent a graph in code:
  
  1. ADJACENCY LIST (What we use)
     - Each vertex has a list of its neighbors
     - Space efficient for sparse graphs: O(V + E)
     - Good for iterating over neighbors
     
     alice -> [bob, charlie, diana, grace]
     bob   -> [alice, charlie, eve, henry]
     
  2. ADJACENCY MATRIX
     - 2D array where matrix[i][j] = 1 if edge exists
     - O(1) edge lookup
     - Space: O(V²) - can be wasteful for sparse graphs
     
           alice  bob  charlie
     alice   0     1      1
     bob     1     0      1
     charlie 1     1      0

"@ "White"
            
            Write-Colored "  Let's see the adjacency matrix for our network!" "Yellow"
            Pause-WithMessage
            Show-AdjacencyMatrix
        }
        
        3 {
            Write-Banner "LESSON 3: BREADTH-FIRST SEARCH (BFS)"
            
            Write-Colored @"

  BFS explores the graph LEVEL BY LEVEL using a QUEUE.
  
  Perfect for finding SHORTEST PATH (degrees of separation)!
  
  HOW IT WORKS:
  1. Start at source vertex, add to queue
  2. Dequeue a vertex, mark as visited
  3. Add all unvisited neighbors to queue
  4. Repeat until target found or queue empty
  
  QUEUE = First-In-First-Out (FIFO)
  
  Example: Finding path from Alice to Henry
  
  Level 0: [alice]
  Level 1: [bob, charlie, diana, grace] (alice's friends)
  Level 2: [eve, frank, henry...] (friends of friends)
           ^ FOUND! Henry is 2 degrees from Alice

"@ "White"
            
            Write-Colored "  Let's watch BFS find the path from 'alice' to 'jack'!" "Yellow"
            Pause-WithMessage
            
            $path = Search-BFS -StartUser "alice" -TargetUser "jack" -Visualize
            
            if ($path) {
                Write-Host ""
                Write-Colored "  SHORTEST PATH FOUND:" "Green"
                Write-Colored ("  " + ($path -join " -> ")) "Yellow"
                Write-Colored "  Degrees of separation: $($path.Count - 1)" "Cyan"
            }
        }
        
        4 {
            Write-Banner "LESSON 4: DEPTH-FIRST SEARCH (DFS)"
            
            Write-Colored @"

  DFS explores as DEEP as possible before backtracking using a STACK.
  
  Good for: Exploring all connections, finding if path exists
  
  HOW IT WORKS:
  1. Start at source vertex, push to stack
  2. Pop a vertex, mark as visited
  3. Push all unvisited neighbors to stack
  4. Repeat until stack empty
  
  STACK = Last-In-First-Out (LIFO)
  
  DFS goes deep down one path before trying others:
  
  alice -> bob -> charlie -> diana -> eve -> frank -> grace -> henry -> ivy -> jack
                                     (backtracks when stuck)

"@ "White"
            
            Write-Colored "  Let's watch DFS explore from 'alice'!" "Yellow"
            Pause-WithMessage
            
            $visitOrder = Search-DFS -StartUser "alice" -Visualize
            
            Write-Host ""
            Write-Colored "  DFS VISIT ORDER:" "Green"
            Write-Colored ("  " + ($visitOrder -join " -> ")) "Yellow"
        }
        
        5 {
            Write-Banner "LESSON 5: FRIEND RECOMMENDATIONS"
            
            Write-Colored @"

  How does Facebook/LinkedIn suggest "People You May Know"?
  
  THE ALGORITHM: Friends of Friends
  
  1. Find all your direct friends (1-hop neighbors)
  2. Find all friends of your friends (2-hop neighbors)
  3. Count mutual connections for each potential friend
  4. Rank by mutual friend count
  5. Remove people you're already friends with
  
  WHY IT WORKS:
  - People with mutual friends are likely to know each other
  - Higher mutual count = stronger recommendation
  - This is essentially counting paths of length 2!
  
  GRAPH THEORY VIEW:
  If there are many paths of length 2 between you and person X,
  you probably should be friends!

"@ "White"
            
            Write-Colored "  Let's see friend recommendations for 'alice'!" "Yellow"
            Pause-WithMessage
            
            Write-Colored "`n  Alice's current friends: $($script:Users['alice'] -join ', ')" "Cyan"
            Write-Host ""
            
            $recommendations = Get-FriendRecommendations -Username "alice" -TopN 5
            
            Write-Colored "  FRIEND RECOMMENDATIONS FOR ALICE:" "Green"
            Write-Host ""
            
            foreach ($rec in $recommendations) {
                $mutuals = Get-MutualFriends -User1 "alice" -User2 $rec.Key
                Write-Colored "    $($rec.Key)" "Yellow" -NoNewLine
                Write-Colored " - $($rec.Value) mutual friend(s): " "White" -NoNewLine
                Write-Colored ($mutuals -join ", ") "DarkGray"
            }
        }
        
        6 {
            Write-Banner "LESSON 6: NETWORK ANALYSIS"
            
            Write-Colored @"

  Social media platforms analyze their networks to understand:
  
  KEY METRICS:
  
  • DEGREE: Number of connections a user has
    High degree = Potential influencer
    
  • DENSITY: Ratio of actual to possible connections
    Dense network = Tight-knit community
    
  • CONNECTED COMPONENTS: Isolated groups in the network
    Multiple components = Separate communities
    
  • CENTRALITY: How "important" a node is
    - Degree centrality: Most connections
    - Betweenness centrality: Controls information flow
    - Closeness centrality: Can reach others quickly

"@ "White"
            
            Write-Colored "  Let's analyze our social network!" "Yellow"
            Pause-WithMessage
            
            $stats = Get-NetworkStatistics
            
            Write-Colored "`n  NETWORK STATISTICS:" "Green"
            Write-Colored "  Total Users (Vertices): $($stats.TotalUsers)" "White"
            Write-Colored "  Total Connections (Edges): $($stats.TotalConnections)" "White"
            Write-Colored "  Average Friends per User: $($stats.AverageFriends)" "White"
            Write-Colored "  Most Connected User: $($stats.MostConnectedUser) ($($stats.MostConnections) friends)" "White"
            Write-Colored "  Network Density: $($stats.NetworkDensity) (0-1 scale)" "White"
            
            Write-Host ""
            Write-Colored "  TOP INFLUENCERS (by connection count):" "Yellow"
            $influencers = Get-Influencers -TopN 5
            foreach ($inf in $influencers) {
                Write-Colored "    $($inf.Key): $($inf.Value) connections" "Cyan"
            }
            
            Write-Host ""
            $components = Find-ConnectedComponents
            Write-Colored "  CONNECTED COMPONENTS: $($components.Count)" "Yellow"
            if ($components.Count -eq 1) {
                Write-Colored "  All users are connected in one network!" "Green"
            }
        }
        
        7 {
            Write-Banner "LESSON 7: DEGREES OF SEPARATION"
            
            Write-Colored @"

  THE SIX DEGREES OF SEPARATION THEORY:
  
  Any two people in the world can be connected through
  at most 6 intermediate connections!
  
  In graph terms: The DIAMETER of the social graph is ~6
  
  HOW WE CALCULATE IT:
  - Use BFS to find shortest path between two users
  - Path length - 1 = Degrees of separation
  
  REAL-WORLD STATS:
  - Facebook (2016): Average 3.57 degrees of separation
  - LinkedIn: Shows connection degree (1st, 2nd, 3rd)
  - Twitter: Different due to directed follow graph

"@ "White"
            
            Write-Colored "  Let's calculate degrees of separation!" "Yellow"
            Pause-WithMessage
            
            Write-Host ""
            $pairs = @(
                @("alice", "jack"),
                @("bob", "ivy"),
                @("charlie", "henry"),
                @("alice", "frank")
            )
            
            foreach ($pair in $pairs) {
                $degrees = Get-DegreesOfSeparation -User1 $pair[0] -User2 $pair[1]
                $path = Search-BFS -StartUser $pair[0] -TargetUser $pair[1]
                
                Write-Colored "  $($pair[0]) <-> $($pair[1]): " "Cyan" -NoNewLine
                Write-Colored "$degrees degrees" "Yellow" -NoNewLine
                Write-Colored " (Path: $($path -join ' -> '))" "DarkGray"
            }
        }
    }
}

function Show-InteractiveMenu {
    while ($true) {
        Clear-Host
        Write-Colored @"
    
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                                                                      ║
    ║           SOCIAL MEDIA GRAPH LEARNING TOOL                          ║
    ║           Understanding Graph Data Structures                        ║
    ║                                                                      ║
    ╠══════════════════════════════════════════════════════════════════════╣
    ║                                                                      ║
    ║   LESSONS:                                                           ║
    ║   [1] What is a Graph? (Vertices & Edges)                           ║
    ║   [2] Graph Representations (Adjacency List vs Matrix)              ║
    ║   [3] Breadth-First Search (BFS) - Shortest Path                    ║
    ║   [4] Depth-First Search (DFS) - Deep Exploration                   ║
    ║   [5] Friend Recommendations Algorithm                               ║
    ║   [6] Network Analysis & Metrics                                     ║
    ║   [7] Degrees of Separation                                          ║
    ║                                                                      ║
    ║   INTERACTIVE:                                                       ║
    ║   [8] Add New User                                                   ║
    ║   [9] Add Friendship                                                 ║
    ║   [10] Find Path Between Users                                       ║
    ║   [11] Get Friend Recommendations                                    ║
    ║   [12] View Network Graph                                            ║
    ║   [13] View Network Statistics                                       ║
    ║   [14] Reset to Sample Network                                       ║
    ║                                                                      ║
    ║   [0] Exit                                                           ║
    ║                                                                      ║
    ╚══════════════════════════════════════════════════════════════════════╝

"@ "Cyan"

        $choice = Read-Host "  Enter your choice"
        
        switch ($choice) {
            "1" { Show-Lesson -LessonNumber 1; Pause-WithMessage }
            "2" { Show-Lesson -LessonNumber 2; Pause-WithMessage }
            "3" { Show-Lesson -LessonNumber 3; Pause-WithMessage }
            "4" { Show-Lesson -LessonNumber 4; Pause-WithMessage }
            "5" { Show-Lesson -LessonNumber 5; Pause-WithMessage }
            "6" { Show-Lesson -LessonNumber 6; Pause-WithMessage }
            "7" { Show-Lesson -LessonNumber 7; Pause-WithMessage }
            "8" {
                Write-Banner "ADD NEW USER"
                $username = Read-Host "  Enter username"
                $fullname = Read-Host "  Enter full name"
                $age = [int](Read-Host "  Enter age")
                $location = Read-Host "  Enter location"
                
                if (Add-User -Username $username -FullName $fullname -Age $age -Location $location) {
                    Write-Colored "  User '$username' added successfully!" "Green"
                }
                Pause-WithMessage
            }
            "9" {
                Write-Banner "ADD FRIENDSHIP"
                Write-Colored "  Current users: $($script:Users.Keys -join ', ')" "Cyan"
                $user1 = Read-Host "  Enter first username"
                $user2 = Read-Host "  Enter second username"
                
                if (Add-Friendship -User1 $user1 -User2 $user2) {
                    Write-Colored "  Friendship created between '$user1' and '$user2'!" "Green"
                }
                Pause-WithMessage
            }
            "10" {
                Write-Banner "FIND PATH BETWEEN USERS"
                Write-Colored "  Current users: $($script:Users.Keys -join ', ')" "Cyan"
                $start = Read-Host "  Enter start username"
                $end = Read-Host "  Enter target username"
                
                $path = Search-BFS -StartUser $start -TargetUser $end -Visualize
                if ($path) {
                    Write-Host ""
                    Write-Colored "  PATH FOUND: $($path -join ' -> ')" "Green"
                    Write-Colored "  Degrees of separation: $($path.Count - 1)" "Yellow"
                } else {
                    Write-Colored "  No path found between these users!" "Red"
                }
                Pause-WithMessage
            }
            "11" {
                Write-Banner "GET FRIEND RECOMMENDATIONS"
                Write-Colored "  Current users: $($script:Users.Keys -join ', ')" "Cyan"
                $user = Read-Host "  Enter username"
                
                $recs = Get-FriendRecommendations -Username $user -TopN 5
                if ($recs) {
                    Write-Colored "`n  RECOMMENDATIONS:" "Green"
                    foreach ($rec in $recs) {
                        Write-Colored "    $($rec.Key) ($($rec.Value) mutual friends)" "Yellow"
                    }
                } else {
                    Write-Colored "  No recommendations available!" "Yellow"
                }
                Pause-WithMessage
            }
            "12" {
                Show-GraphVisualization
                Pause-WithMessage
            }
            "13" {
                Write-Banner "NETWORK STATISTICS"
                $stats = Get-NetworkStatistics
                Write-Colored "  Total Users: $($stats.TotalUsers)" "White"
                Write-Colored "  Total Connections: $($stats.TotalConnections)" "White"
                Write-Colored "  Average Friends: $($stats.AverageFriends)" "White"
                Write-Colored "  Most Connected: $($stats.MostConnectedUser) ($($stats.MostConnections) friends)" "White"
                Write-Colored "  Network Density: $($stats.NetworkDensity)" "White"
                
                $influencers = Get-Influencers -TopN 5
                Write-Host ""
                Write-Colored "  TOP INFLUENCERS:" "Yellow"
                foreach ($inf in $influencers) {
                    Write-Colored "    $($inf.Key): $($inf.Value) connections" "Cyan"
                }
                Pause-WithMessage
            }
            "14" {
                Initialize-SampleNetwork
                Write-Colored "  Sample network restored!" "Green"
                Pause-WithMessage
            }
            "0" {
                Write-Colored "`n  Thank you for learning about Graph Data Structures!" "Green"
                Write-Colored "  Remember: Social media is just a giant graph!" "Yellow"
                return
            }
            default {
                Write-Colored "  Invalid choice. Please try again." "Red"
                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================================
# SECTION 9: MAIN ENTRY POINT
# ============================================================================

# Initialize the sample network
Initialize-SampleNetwork

# Show the interactive menu
Show-InteractiveMenu
