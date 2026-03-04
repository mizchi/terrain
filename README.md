# terrain

69 dungeon/terrain generation algorithms in [MoonBit](https://www.moonbitlang.com/).

[Live Playground](https://mizchi.github.io/terrain/)

## Algorithms

### Maze (11)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| Maze (DFS) | `maze` | `classic` `perfect-maze` | Recursive backtracker depth-first search |
| Eller's Maze | `eller` | `classic` `row-by-row` | Row-by-row generation with set merging |
| Kruskal's Maze | `kruskal` | `classic` `mst` | Minimum spanning tree randomized maze |
| Binary Tree Maze | `binary_tree` | `classic` `simple` | Two-direction bias with diagonal tendency |
| Sidewinder Maze | `sidewinder` | `classic` `row-by-row` | Horizontal runs with random vertical connections |
| Recursive Division | `recursive_division` | `classic` `divide` | Recursive wall placement subdivision |
| Growing Tree | `growing_tree` | `configurable` `perfect-maze` | Tunable between DFS and Prim's via weight |
| Wilson's | `wilson` | `unbiased` `perfect-maze` | Loop-erased random walk for uniform spanning tree |
| Aldous-Broder | `aldous_broder` | `unbiased` `perfect-maze` | Random walk visiting every cell exactly once |
| Hunt and Kill | `hunt_and_kill` | `classic` `perfect-maze` | Walk until stuck, then scan for unvisited neighbor |
| Pac-Man Maze | `pacman` | `symmetric` `arcade` | Bilaterally symmetric maze with central chamber |

### Room Placement (11)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| BSP Tree | `bsp` | `partition` `balanced` | Binary space partition with rooms in leaves |
| Poisson Disk | `poisson` | `sampling` `even-spacing` | Blue noise distributed room placement |
| Rooms and Mazes | `rooms_and_mazes` | `hybrid` `connect` | Place rooms then fill gaps with maze corridors |
| Rogue Classic | `rogue` | `grid` `retro` | Grid-based room layout inspired by original Rogue |
| Room Accretion | `accretion` | `incremental` `organic` | Grow dungeon by adding rooms one at a time |
| TinyKeep | `tinykeep` | `physics` `separation` | Random rooms with physics-based separation |
| Feature Growing | `feature_growing` | `incremental` `corridors` | Grow by attaching rooms and corridors to exits |
| BFS Room Expansion | `bfs_rooms` | `flood-fill` `organic` | Seed-based parallel flood fill room growing |
| Prefab Assembly | `prefab` | `template` `modular` | Place predefined room templates randomly |
| Gravity Collapse | `gravity_collapse` | `physics` `stacking` | Drop rooms from top, stack with gravity simulation |
| Tetromino Packing | `tetromino` | `puzzle` `packing` | Pack tetris-shaped pieces into grid |

### Cave / Organic (16)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| Cellular Automata | `cellular` | `ca` `natural` | Conway-style birth/survival cave generation |
| Drunkard's Walk | `drunkard` | `random-walk` `simple` | Random walker carving open space |
| Noise Caves | `noise_caves` | `perlin` `continuous` | Value noise with octaves for smooth caves |
| DLA | `dla` | `fractal` `aggregation` | Diffusion-limited aggregation particle sticking |
| Marching Squares | `marching_squares` | `ca` `smooth` | Cellular automata with contour smoothing |
| Worm Tunnels | `worm` | `agent` `tunneling` | Multiple directional worms carving passages |
| Erosion | `erosion` | `simulation` `water` | Hydraulic erosion simulation on heightmap |
| Percolation | `percolation` | `math` `threshold` | Random fill with connectivity phase transition |
| Ant Colony | `ant_colony` | `swarm` `emergent` | Pheromone-guided ant swarm carving paths |
| Worley Noise | `worley` | `voronoi` `cellular` | Worley/cellular noise distance-based caves |
| Ridged Multifractal | `ridged` | `noise` `sharp` | Ridged multifractal noise with sharp ridges |
| Domain Warping | `domain_warp` | `noise` `distortion` | Noise with coordinate warping for organic shapes |
| Reaction-Diffusion | `reaction_diffusion` | `simulation` `turing` | Gray-Scott reaction-diffusion pattern formation |
| Slime Mold | `slime_mold` | `agent` `emergent` | Physarum-inspired slime mold agent simulation |
| Lightning | `lightning` | `fractal` `branching` | Lightning bolt branching path generation |

### Graph / Structure (10)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| Graph Grammar | `graph_grammar` | `formal` `lock-key` | Rule-based graph rewriting with locks and keys |
| Diablo | `diablo` | `spine` `branching` | Linear spine with branching side paths and loops |
| Spelunky | `spelunky` | `grid-path` `platformer` | Grid cells with guaranteed solution path |
| Arena Chain | `arena_chain` | `boss-rooms` `linear` | Large arenas connected by narrow corridors |
| Cyclic Dungeon | `cyclic_dungeon` | `loops` `lock-key` | Circular connectivity with key-gate puzzles |
| Metroidvania | `metroidvania` | `zones` `gates` | Multi-zone layout with ability-gated connections |
| Mission Graph | `mission_graph` | `narrative` `branching` | Mission-driven node graph with lock progression |
| Ring Dungeon | `ring` | `loop` `shortcuts` | Ring corridor with rooms and Dark Souls shortcuts |
| Binding of Isaac | `isaac` | `grid` `game-specific` | Grid-based room layout inspired by Isaac |
| Dead Cells | `dead_cells` | `biome` `game-specific` | Branching biome path layout inspired by Dead Cells |

### Space Filling (4)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| Hilbert Curve | `hilbert` | `fractal` `order-n` | Hilbert space-filling curve as corridor backbone |
| Gosper Curve | `gosper` | `fractal` `hexagonal` | Flowsnake L-system curve on hex-like grid |
| Spiral | `spiral` | `geometric` `archimedean` | Archimedean spiral with rooms at intervals |
| Sierpinski Dungeon | `sierpinski` | `fractal` `recursive` | Sierpinski carpet recursive subdivision |

### Terrain (5)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| Diamond-Square | `diamond_square` | `heightmap` `fractal` | Fractal heightmap with configurable roughness |
| Midpoint Displacement | `midpoint_displacement` | `heightmap` `layers` | Multi-layer midpoint displacement terrain |
| Island/Archipelago | `island` | `islands` `bridges` | Circular islands connected by bridges |
| River/Watershed | `river` | `simulation` `water` | Heightmap with hydraulic river carving |
| Crystal Growth | `crystal` | `growth` `geometric` | Axis-aligned crystal seed growth |

### Pattern / Tiling (7)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| WFC | `wfc` | `constraint` `local-rules` | Wave Function Collapse tile solver |
| Superimposition | `superimpose` | `stamp` `overlap` | Overlapping random shape stamps |
| Herringbone Wang Tiles | `herringbone` | `tiling` `structured` | Herringbone pattern tile placement |
| L-System | `lsystem` | `grammar` `growth` | Lindenmayer system string rewriting paths |
| Hex Grid | `hex_grid` | `hexagonal` `grid` | Hexagonal cell grid with corridor connections |
| City Block | `city_block` | `urban` `streets` | Street grid with buildings and dead ends |
| Penrose Tiling | `penrose` | `aperiodic` `geometric` | Penrose-inspired aperiodic tiling dungeon |

### Hybrid (6)

| Name | Package | Tags | Description |
|------|---------|------|-------------|
| Voronoi Region | `voronoi` | `diagram` `regions` | Voronoi cell regions with edge corridors |
| Radial | `radial` | `concentric` `rings` | Concentric rings with spokes and gaps |
| Space Colonization | `space_colonization` | `growth` `organic` | Attractor-based branching path growth |
| Parametric Tunnelers | `tunneler` | `agent` `variable-width` | Multiple autonomous tunneling agents |
| Platformer Level | `platformer` | `side-scroll` `platforms` | Side-scrolling level with platforms and ladders |
| Delaunay + Gabriel | `delaunay` | `triangulation` `graph` | Delaunay triangulation with Gabriel graph pruning |

## Development

```bash
# Install MoonBit
curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash

# Check
just check

# Test
just test

# Build web playground
just web

# Serve locally
just serve
# Open http://localhost:8080
```

## License

MIT
