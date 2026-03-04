///|
fn run_algorithm(name : String, grid : @types.Grid2D, room_count : Int) -> Unit {
  println("=== " + name + " ===")
  println(grid.to_ascii())
  let metrics = @types.compute_metrics(grid, room_count)
  println(
    "  open_ratio: " + metrics.open_ratio.to_string() +
    "  rooms: " + metrics.room_count.to_string() +
    "  connected: " + metrics.connectivity.to_string() +
    "  largest: " + metrics.largest_component.to_string() +
    "  dead_ends: " + metrics.dead_end_count.to_string(),
  )
  println("")
}

///|
fn main {
  let seed = 42U
  println("terrain - dungeon generation algorithms (seed=" + seed.to_string() + ")")
  println("")
  // 1. Drunkard's Walk
  let rng = @types.make_rng(seed)
  let dr = @drunkard.generate(@drunkard.DrunkardConfig::default(), rng)
  run_algorithm("Drunkard's Walk", dr.grid, 0)
  // 2. Cellular Automata
  let rng = @types.make_rng(seed)
  let ca = @cellular.generate(@cellular.CellularConfig::default(), rng)
  run_algorithm("Cellular Automata", ca.grid, 0)
  // 3. BSP Tree
  let rng = @types.make_rng(seed)
  let bsp = @bsp.generate(@bsp.BspConfig::default(), rng)
  run_algorithm("BSP Tree", bsp.grid, bsp.rooms.length())
  // 4. Poisson Disk
  let rng = @types.make_rng(seed)
  let ps = @poisson.generate(@poisson.PoissonConfig::default(), rng)
  run_algorithm("Poisson Disk", ps.grid, ps.rooms.length())
  // 5. Graph Grammar
  let rng = @types.make_rng(seed)
  let gg = @graph_grammar.generate(@graph_grammar.GraphGrammarConfig::default(), rng)
  run_algorithm("Graph Grammar", gg.grid, gg.rooms.length())
  // 6. WFC
  let rng = @types.make_rng(seed)
  let wfc = @wfc.generate(@wfc.WfcConfig::default(), rng)
  run_algorithm("WFC (success=" + wfc.success.to_string() + ")", wfc.grid, 0)
  // 7. Diablo
  let rng = @types.make_rng(seed)
  let diablo = @diablo.generate(@diablo.DiabloConfig::default(), rng)
  run_algorithm("Diablo", diablo.grid, diablo.rooms.length())
  // 8. Spelunky
  let rng = @types.make_rng(seed)
  let spelunky = @spelunky.generate(@spelunky.SpelunkyConfig::default(), rng)
  run_algorithm("Spelunky", spelunky.grid, spelunky.rooms.length())
  // 9. Arena Chain
  let rng = @types.make_rng(seed)
  let arena = @arena_chain.generate(@arena_chain.ArenaChainConfig::default(), rng)
  run_algorithm("Arena Chain", arena.grid, arena.rooms.length())
  // 10. Voronoi Region
  let rng = @types.make_rng(seed)
  let voronoi = @voronoi.generate(@voronoi.VoronoiConfig::default(), rng)
  run_algorithm("Voronoi Region", voronoi.grid, voronoi.rooms.length())
  // 11. Maze
  let rng = @types.make_rng(seed)
  let mz = @maze.generate(@maze.MazeConfig::default(), rng)
  run_algorithm("Maze (DFS)", mz.grid, mz.rooms.length())
  // 12. Rooms and Mazes
  let rng = @types.make_rng(seed)
  let rm = @rooms_and_mazes.generate(
    @rooms_and_mazes.RoomsAndMazesConfig::default(),
    rng,
  )
  run_algorithm("Rooms and Mazes", rm.grid, rm.rooms.length())
  // 13. Radial
  let rng = @types.make_rng(seed)
  let rad = @radial.generate(@radial.RadialConfig::default(), rng)
  run_algorithm("Radial", rad.grid, rad.rooms.length())
  // 14. DLA
  let rng = @types.make_rng(seed)
  let dla = @dla.generate(@dla.DlaConfig::default(), rng)
  run_algorithm("DLA", dla.grid, dla.particles)
  // 15. Worm Tunnels
  let rng = @types.make_rng(seed)
  let worm = @worm.generate(@worm.WormConfig::default(), rng)
  run_algorithm("Worm Tunnels", worm.grid, worm.rooms.length())
  // 16. Rogue Classic
  let rng = @types.make_rng(seed)
  let rogue = @rogue.generate(@rogue.RogueConfig::default(), rng)
  run_algorithm("Rogue Classic", rogue.grid, rogue.rooms.length())
  // 17. Room Accretion
  let rng = @types.make_rng(seed)
  let acc = @accretion.generate(@accretion.AccretionConfig::default(), rng)
  run_algorithm("Room Accretion", acc.grid, acc.rooms.length())
  // 18. TinyKeep
  let rng = @types.make_rng(seed)
  let tk = @tinykeep.generate(@tinykeep.TinyKeepConfig::default(), rng)
  run_algorithm("TinyKeep", tk.grid, tk.rooms.length())
  // 19. Feature Growing
  let rng = @types.make_rng(seed)
  let fg = @feature_growing.generate(
    @feature_growing.FeatureGrowingConfig::default(),
    rng,
  )
  run_algorithm("Feature Growing", fg.grid, fg.rooms.length())
  // 20. Noise Caves
  let rng = @types.make_rng(seed)
  let nc = @noise_caves.generate(@noise_caves.NoiseCavesConfig::default(), rng)
  run_algorithm("Noise Caves", nc.grid, nc.open_cells)
  // 21. Superimposition
  let rng = @types.make_rng(seed)
  let si = @superimpose.generate(@superimpose.SuperimposeConfig::default(), rng)
  run_algorithm("Superimposition", si.grid, si.rooms.length())
  // 22. Eller's Maze
  let rng = @types.make_rng(seed)
  let el = @eller.generate(@eller.EllerConfig::default(), rng)
  run_algorithm("Eller's Maze", el.grid, el.rooms.length())
  // 23. Parametric Tunnelers
  let rng = @types.make_rng(seed)
  let tn = @tunneler.generate(@tunneler.TunnelerConfig::default(), rng)
  run_algorithm("Parametric Tunnelers", tn.grid, tn.rooms.length())
  // 24. BFS Room Expansion
  let rng = @types.make_rng(seed)
  let bf = @bfs_rooms.generate(@bfs_rooms.BfsRoomsConfig::default(), rng)
  run_algorithm("BFS Room Expansion", bf.grid, bf.rooms.length())
  // 25. Kruskal's Maze
  let rng = @types.make_rng(seed)
  let kr = @kruskal.generate(@kruskal.KruskalConfig::default(), rng)
  run_algorithm("Kruskal's Maze", kr.grid, kr.rooms.length())
  // 26. Recursive Division
  let rng = @types.make_rng(seed)
  let rd = @recursive_division.generate(
    @recursive_division.RecursiveDivisionConfig::default(),
    rng,
  )
  run_algorithm("Recursive Division", rd.grid, rd.rooms.length())
  // 27. Binary Tree Maze
  let rng = @types.make_rng(seed)
  let bt = @binary_tree.generate(@binary_tree.BinaryTreeConfig::default(), rng)
  run_algorithm("Binary Tree Maze", bt.grid, bt.rooms.length())
  // 28. Sidewinder Maze
  let rng = @types.make_rng(seed)
  let sw = @sidewinder.generate(@sidewinder.SidewinderConfig::default(), rng)
  run_algorithm("Sidewinder Maze", sw.grid, sw.rooms.length())
  // 29. Diamond-Square
  let rng = @types.make_rng(seed)
  let ds = @diamond_square.generate(
    @diamond_square.DiamondSquareConfig::default(),
    rng,
  )
  run_algorithm("Diamond-Square", ds.grid, ds.rooms.length())
  // 30. Space Colonization
  let rng = @types.make_rng(seed)
  let sc = @space_colonization.generate(
    @space_colonization.SpaceColonizationConfig::default(),
    rng,
  )
  run_algorithm("Space Colonization", sc.grid, sc.rooms.length())
  // 31. Hilbert Curve
  let rng = @types.make_rng(seed)
  let hb = @hilbert.generate(@hilbert.HilbertConfig::default(), rng)
  run_algorithm("Hilbert Curve", hb.grid, hb.rooms.length())
  // 32. Prefab Assembly
  let rng = @types.make_rng(seed)
  let pf = @prefab.generate(@prefab.PrefabConfig::default(), rng)
  run_algorithm("Prefab Assembly", pf.grid, pf.rooms.length())
}
