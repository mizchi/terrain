///|
extern "js" fn js_export_generate(
  f : (Int, Int, Int, Int) -> String,
) -> Unit =
  #| (f) => { globalThis.__terrain_generate = f; }

///|
extern "js" fn js_set_cells(csv : String) -> Unit =
  #| (csv) => { globalThis.__terrain_cells = csv; }

///|
extern "js" fn js_set_metrics(json : String) -> Unit =
  #| (json) => { globalThis.__terrain_metrics = json; }

///|
extern "js" fn js_get_param(index : Int, default_val : Double) -> Double =
  #| (i, d) => { const p = globalThis.__terrain_params; return (p && i < p.length) ? p[i] : d; }

///|
fn tile_to_int(tile : @types.Tile) -> Int {
  match tile {
    Floor => 0
    Wall => 1
    Door => 2
    LockedDoor => 3
    Key => 4
    Start => 5
    Goal => 6
    Corridor => 7
    Water => 8
    Empty => 9
  }
}

///|
fn grid_to_cells_csv(grid : @types.Grid2D) -> String {
  let buf = StringBuilder::new()
  for i in 0..<grid.cells.length() {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string(tile_to_int(grid.cells[i]).to_string())
  }
  buf.to_string()
}

///|
fn metrics_to_json(metrics : @types.GridMetrics) -> String {
  let buf = StringBuilder::new()
  buf.write_string("{\"open_ratio\":")
  buf.write_string(metrics.open_ratio.to_string())
  buf.write_string(",\"room_count\":")
  buf.write_string(metrics.room_count.to_string())
  buf.write_string(",\"connected\":")
  buf.write_string(metrics.connectivity.to_string())
  buf.write_string(",\"largest_component\":")
  buf.write_string(metrics.largest_component.to_string())
  buf.write_string(",\"dead_end_count\":")
  buf.write_string(metrics.dead_end_count.to_string())
  buf.write_string("}")
  buf.to_string()
}

///|
fn p(index : Int, default_val : Double) -> Double {
  js_get_param(index, default_val)
}

///|
fn pi(index : Int, default_val : Int) -> Int {
  js_get_param(index, default_val.to_double()).to_int()
}

///|
fn finish(grid : @types.Grid2D, room_count : Int) -> String {
  js_set_cells(grid_to_cells_csv(grid))
  let metrics = @types.compute_metrics(grid, room_count)
  js_set_metrics(metrics_to_json(metrics))
  grid.to_ascii()
}

///|
fn dispatch(algo_id : Int, seed : Int, width : Int, height : Int) -> String {
  let rng = @types.make_rng(seed.reinterpret_as_uint())
  match algo_id {
    0 => {
      let r = @drunkard.generate(
        {
          width,
          height,
          fill_ratio: p(0, 0.4),
          max_steps: pi(1, 5000),
        },
        rng,
      )
      finish(r.grid, 0)
    }
    1 => {
      let r = @cellular.generate(
        {
          width,
          height,
          initial_fill: p(0, 0.45),
          iterations: pi(1, 5),
          birth_threshold: pi(2, 5),
          survival_threshold: pi(3, 4),
        },
        rng,
      )
      finish(r.grid, 0)
    }
    2 => {
      let r = @bsp.generate(
        { width, height, min_room_size: pi(0, 4), max_depth: pi(1, 4) },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    3 => {
      let r = @poisson.generate(
        {
          width,
          height,
          min_distance: pi(0, 8),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 6),
          max_attempts: pi(3, 30),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    4 => {
      let r = @graph_grammar.generate(
        {
          width,
          height,
          num_rooms: pi(0, 6),
          num_locks: pi(1, 2),
          room_size: pi(2, 4),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    5 => {
      let r = @wfc.generate(
        { width, height, max_retries: pi(0, 10) },
        rng,
      )
      finish(r.grid, 0)
    }
    6 => {
      let r = @diablo.generate(
        {
          width,
          height,
          spine_length: pi(0, 6),
          branch_chance: p(1, 0.5),
          loop_chance: p(2, 0.25),
          room_min_size: pi(3, 3),
          room_max_size: pi(4, 9),
          room_padding: pi(5, 2),
          max_placement_attempts: pi(6, 50),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    7 => {
      let r = @spelunky.generate(
        {
          width,
          height,
          grid_cols: pi(0, 4),
          grid_rows: pi(1, 4),
          room_min_size: pi(2, 3),
          room_max_size: pi(3, 5),
          off_path_chance: p(4, 0.3),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    8 => {
      let r = @arena_chain.generate(
        {
          width,
          height,
          num_arenas: pi(0, 5),
          arena_min_size: pi(1, 7),
          arena_max_size: pi(2, 13),
          corridor_width: pi(3, 2),
          side_room_chance: p(4, 0.4),
          side_room_min_size: pi(5, 3),
          side_room_max_size: pi(6, 5),
          max_placement_attempts: pi(7, 50),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    9 => {
      let r = @voronoi.generate(
        {
          width,
          height,
          num_seeds: pi(0, 8),
          shrink: pi(1, 1),
          extra_edge_chance: p(2, 0.2),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    10 => {
      let r = @maze.generate(
        {
          width,
          height,
          room_chance: p(0, 0.15),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    11 => {
      let r = @rooms_and_mazes.generate(
        {
          width,
          height,
          num_room_attempts: pi(0, 50),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 7),
          winding_chance: p(3, 0.3),
          extra_connector_chance: p(4, 0.02),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    12 => {
      let r = @radial.generate(
        {
          width,
          height,
          num_rings: pi(0, 4),
          sectors_per_ring: pi(1, 8),
          ring_width: pi(2, 3),
          spoke_chance: p(3, 0.6),
          gap_chance: p(4, 0.2),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    13 => {
      let r = @dla.generate(
        {
          width,
          height,
          target_fill: p(0, 0.35),
          max_walk_steps: pi(1, 500),
          num_seeds: pi(2, 3),
        },
        rng,
      )
      finish(r.grid, r.particles)
    }
    14 => {
      let r = @worm.generate(
        {
          width,
          height,
          num_worms: pi(0, 4),
          worm_length: pi(1, 60),
          worm_min_width: pi(2, 1),
          worm_max_width: pi(3, 3),
          turn_chance: p(4, 0.3),
          room_chance: p(5, 0.08),
          room_min_size: pi(6, 3),
          room_max_size: pi(7, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    15 => {
      let r = @rogue.generate(
        {
          width,
          height,
          grid_cols: pi(0, 3),
          grid_rows: pi(1, 3),
          room_min_ratio: p(2, 0.4),
          room_max_ratio: p(3, 0.8),
          skip_chance: p(4, 0.15),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    16 => {
      let r = @accretion.generate(
        {
          width,
          height,
          max_rooms: pi(0, 12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 8),
          max_attempts_per_room: pi(3, 100),
          first_room_size: pi(4, 6),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    17 => {
      let r = @tinykeep.generate(
        {
          width,
          height,
          num_rooms: pi(0, 30),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 9),
          main_room_threshold: pi(3, 5),
          extra_edge_chance: p(4, 0.15),
          separation_iterations: pi(5, 50),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    18 => {
      let r = @feature_growing.generate(
        {
          width,
          height,
          max_features: pi(0, 30),
          max_attempts: pi(1, 500),
          room_min_size: pi(2, 3),
          room_max_size: pi(3, 7),
          corridor_min_len: pi(4, 3),
          corridor_max_len: pi(5, 8),
          room_weight: pi(6, 3),
          corridor_weight: pi(7, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    19 => {
      let r = @noise_caves.generate(
        {
          width,
          height,
          threshold: p(0, 0.45),
          octaves: pi(1, 4),
          scale: p(2, 0.08),
          persistence: p(3, 0.5),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    20 => {
      let r = @superimpose.generate(
        {
          width,
          height,
          num_stamps: pi(0, 40),
          rect_weight: pi(1, 4),
          circle_weight: pi(2, 2),
          corridor_h_weight: pi(3, 3),
          corridor_v_weight: pi(4, 3),
          stamp_min_size: pi(5, 3),
          stamp_max_size: pi(6, 8),
          corridor_min_len: pi(7, 4),
          corridor_max_len: pi(8, 12),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    21 => {
      let r = @eller.generate(
        {
          width,
          height,
          merge_chance: p(0, 0.5),
          room_chance: p(1, 0.12),
          room_min_size: pi(2, 3),
          room_max_size: pi(3, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    22 => {
      let r = @tunneler.generate(
        {
          width,
          height,
          num_tunnelers: pi(0, 3),
          tunnel_length: pi(1, 80),
          initial_width: pi(2, 1),
          max_width: pi(3, 4),
          turn_chance: p(4, 0.2),
          width_change_chance: p(5, 0.1),
          room_chance: p(6, 0.06),
          room_min_size: pi(7, 3),
          room_max_size: pi(8, 7),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    23 => {
      let r = @bfs_rooms.generate(
        {
          width,
          height,
          num_seeds: pi(0, 10),
          min_room_size: pi(1, 8),
          parallel_steps: pi(2, 12),
          serial_steps: pi(3, 20),
          door_chance: p(4, 0.8),
          extra_door_chance: p(5, 0.15),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    24 => {
      let r = @kruskal.generate(
        {
          width,
          height,
          room_chance: p(0, 0.12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    25 => {
      let r = @recursive_division.generate(
        {
          width,
          height,
          min_room_size: pi(0, 3),
          room_chance: p(1, 0.1),
          room_min_size: pi(2, 3),
          room_max_size: pi(3, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    26 => {
      let r = @binary_tree.generate(
        {
          width,
          height,
          room_chance: p(0, 0.12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    27 => {
      let r = @sidewinder.generate(
        {
          width,
          height,
          carve_chance: p(0, 0.5),
          room_chance: p(1, 0.12),
          room_min_size: pi(2, 3),
          room_max_size: pi(3, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    28 => {
      let r = @diamond_square.generate(
        {
          width,
          height,
          roughness: p(0, 0.6),
          threshold: p(1, 0.45),
          initial_range: p(2, 1.0),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    29 => {
      let r = @space_colonization.generate(
        {
          width,
          height,
          num_attractors: pi(0, 80),
          kill_distance: pi(1, 2),
          influence_distance: pi(2, 15),
          step_size: pi(3, 1),
          corridor_width: pi(4, 1),
          room_chance: p(5, 0.15),
          room_min_size: pi(6, 3),
          room_max_size: pi(7, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    30 => {
      let r = @hilbert.generate(
        {
          width,
          height,
          order: pi(0, 4),
          corridor_width: pi(1, 1),
          room_chance: p(2, 0.08),
          room_min_size: pi(3, 3),
          room_max_size: pi(4, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    31 => {
      let r = @prefab.generate(
        { width, height, num_prefabs: pi(0, 12), max_attempts: pi(1, 100) },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    32 => {
      let r = @growing_tree.generate(
        {
          width,
          height,
          newest_weight: p(0, 1.0),
          room_chance: p(1, 0.12),
          room_min_size: pi(2, 3),
          room_max_size: pi(3, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    33 => {
      let r = @wilson.generate(
        {
          width,
          height,
          room_chance: p(0, 0.12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    34 => {
      let r = @aldous_broder.generate(
        {
          width,
          height,
          room_chance: p(0, 0.12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    35 => {
      let r = @hunt_and_kill.generate(
        {
          width,
          height,
          room_chance: p(0, 0.12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    36 => {
      let r = @erosion.generate(
        {
          width,
          height,
          num_drops: pi(0, 500),
          erosion_strength: p(1, 0.1),
          deposition_rate: p(2, 0.05),
          threshold: p(3, 0.45),
        },
        rng,
      )
      finish(r.grid, r.rivers)
    }
    37 => {
      let r = @midpoint_displacement.generate(
        {
          width,
          height,
          roughness: p(0, 0.5),
          num_layers: pi(1, 3),
          threshold: p(2, 0.5),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    38 => {
      let r = @island.generate(
        {
          width,
          height,
          num_islands: pi(0, 5),
          island_min_radius: pi(1, 3),
          island_max_radius: pi(2, 7),
          bridge_width: pi(3, 1),
          fill_ratio: p(4, 0.4),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    39 => {
      let r = @cyclic_dungeon.generate(
        {
          width,
          height,
          num_rooms: pi(0, 8),
          num_keys: pi(1, 2),
          cycle_chance: p(2, 0.3),
          room_min_size: pi(3, 4),
          room_max_size: pi(4, 7),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    40 => {
      let r = @metroidvania.generate(
        {
          width,
          height,
          num_zones: pi(0, 4),
          rooms_per_zone: pi(1, 4),
          gate_chance: p(2, 0.3),
          room_min_size: pi(3, 4),
          room_max_size: pi(4, 8),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    41 => {
      let r = @mission_graph.generate(
        {
          width,
          height,
          num_nodes: pi(0, 10),
          branch_chance: p(1, 0.3),
          lock_chance: p(2, 0.2),
          room_min_size: pi(3, 4),
          room_max_size: pi(4, 7),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    42 => {
      let r = @herringbone.generate(
        {
          width,
          height,
          tile_size: pi(0, 6),
          floor_ratio: p(1, 0.5),
          corridor_chance: p(2, 0.3),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    43 => {
      let r = @lsystem.generate(
        {
          width,
          height,
          iterations: pi(0, 4),
          segment_length: pi(1, 2),
          turn_angle: pi(2, 2),
          room_chance: p(3, 0.15),
          room_min_size: pi(4, 3),
          room_max_size: pi(5, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    44 => {
      let r = @marching_squares.generate(
        {
          width,
          height,
          initial_fill: p(0, 0.45),
          ca_iterations: pi(1, 5),
          birth_threshold: pi(2, 5),
          survival_threshold: pi(3, 4),
          smooth: pi(4, 1) != 0,
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    45 => {
      let r = @ant_colony.generate(
        {
          width,
          height,
          num_ants: pi(0, 10),
          steps_per_ant: pi(1, 200),
          pheromone_strength: p(2, 1.0),
          evaporation_rate: p(3, 0.1),
          room_chance: p(4, 0.1),
          room_min_size: pi(5, 3),
          room_max_size: pi(6, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    46 => {
      let r = @percolation.generate(
        {
          width,
          height,
          open_chance: p(0, 0.55),
          widen: pi(1, 1),
          min_component_size: pi(2, 10),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    47 => {
      let r = @gravity_collapse.generate(
        {
          width,
          height,
          num_rooms: pi(0, 12),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 7),
          corridor_width: pi(3, 1),
          gap: pi(4, 0),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    48 => {
      let r = @sierpinski.generate(
        {
          width,
          height,
          depth: pi(0, 3),
          corridor_width: pi(1, 1),
          room_chance: p(2, 0.1),
          room_min_size: pi(3, 3),
          room_max_size: pi(4, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    49 => {
      let r = @spiral.generate(
        {
          width,
          height,
          spacing: pi(0, 3),
          corridor_width: pi(1, 1),
          room_chance: p(2, 0.2),
          room_min_size: pi(3, 3),
          room_max_size: pi(4, 5),
          num_turns: pi(5, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    50 => {
      let r = @gosper.generate(
        {
          width,
          height,
          order: pi(0, 3),
          corridor_width: pi(1, 1),
          room_chance: p(2, 0.1),
          room_min_size: pi(3, 3),
          room_max_size: pi(4, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    51 => {
      let r = @platformer.generate(
        {
          width,
          height,
          num_platforms: pi(0, 15),
          platform_min_len: pi(1, 3),
          platform_max_len: pi(2, 8),
          ladder_chance: p(3, 0.3),
          gap_chance: p(4, 0.2),
          water_level: pi(5, 2),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    52 => {
      let r = @ring.generate(
        {
          width,
          height,
          ring_padding: pi(0, 4),
          num_rooms: pi(1, 8),
          room_min_size: pi(2, 4),
          room_max_size: pi(3, 7),
          num_shortcuts: pi(4, 2),
          shortcut_width: pi(5, 1),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    53 => {
      let r = @pacman.generate(
        {
          width,
          height,
          wall_density: p(0, 0.3),
          corridor_width: pi(1, 2),
          chamber_size: pi(2, 5),
          symmetry: pi(3, 0),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    54 => {
      let r = @tetromino.generate(
        {
          width,
          height,
          max_attempts: pi(0, 200),
          connect_adjacent: pi(1, 1) != 0,
          corridor_width: pi(2, 1),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    55 => {
      let r = @hex_grid.generate(
        {
          width,
          height,
          hex_size: pi(0, 4),
          open_chance: p(1, 0.5),
          extra_wall_chance: p(2, 0.2),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    56 => {
      let r = @city_block.generate(
        {
          width,
          height,
          block_size: pi(0, 6),
          street_width: pi(1, 1),
          building_chance: p(2, 0.7),
          door_chance: p(3, 0.5),
          remove_street_chance: p(4, 0.15),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    57 => {
      let r = @worley.generate(
        {
          width,
          height,
          num_points: pi(0, 20),
          threshold: p(1, 0.3),
          use_manhattan: pi(2, 1),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    58 => {
      let r = @ridged.generate(
        {
          width,
          height,
          octaves: pi(0, 4),
          scale: p(1, 0.06),
          persistence: p(2, 0.5),
          lacunarity: p(3, 2.0),
          threshold: p(4, 0.5),
          sharpness: p(5, 2.0),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    59 => {
      let r = @domain_warp.generate(
        {
          width,
          height,
          scale: p(0, 0.08),
          warp_strength: p(1, 4.0),
          warp_iterations: pi(2, 2),
          threshold: p(3, 0.45),
          octaves: pi(4, 3),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    60 => {
      let r = @reaction_diffusion.generate(
        {
          width,
          height,
          iterations: pi(0, 3000),
          du: p(1, 1.0),
          dv: p(2, 0.5),
          feed: p(3, 0.055),
          kill: p(4, 0.062),
          threshold: p(5, 0.2),
          dt: p(6, 1.0),
        },
        rng,
      )
      finish(r.grid, r.open_cells)
    }
    61 => {
      let r = @river.generate(
        {
          width,
          height,
          num_drops: pi(0, 200),
          noise_scale: p(1, 0.08),
          height_threshold: p(2, 0.5),
          river_width: pi(3, 1),
          num_sources: pi(4, 5),
        },
        rng,
      )
      finish(r.grid, r.rivers)
    }
    62 => {
      let r = @crystal.generate(
        {
          width,
          height,
          num_seeds: pi(0, 8),
          growth_steps: pi(1, 100),
          axis_bias: p(2, 0.7),
          connect_chance: p(3, 0.8),
          min_crystal_size: pi(4, 4),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    63 => {
      let r = @slime_mold.generate(
        {
          width,
          height,
          num_agents: pi(0, 200),
          num_food: pi(1, 5),
          steps: pi(2, 300),
          sensor_angle: pi(3, 1),
          sensor_distance: pi(4, 3),
          deposit_amount: p(5, 1.0),
          decay_rate: p(6, 0.1),
          threshold: p(7, 0.5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    64 => {
      let r = @lightning.generate(
        {
          width,
          height,
          num_bolts: pi(0, 3),
          branch_chance: p(1, 0.3),
          max_steps: pi(2, 500),
          room_chance: p(3, 0.15),
          room_min_size: pi(4, 3),
          room_max_size: pi(5, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    65 => {
      let r = @isaac.generate(
        {
          width,
          height,
          room_size: pi(0, 9),
          num_rooms: pi(1, 12),
          min_rooms: pi(2, 8),
          max_dead_ends: pi(3, 4),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    66 => {
      let r = @dead_cells.generate(
        {
          width,
          height,
          path_length: pi(0, 5),
          max_branches: pi(1, 3),
          branch_chance: p(2, 0.4),
          shortcut_chance: p(3, 0.2),
          biome_min_size: pi(4, 6),
          biome_max_size: pi(5, 10),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    67 => {
      let r = @penrose.generate(
        {
          width,
          height,
          num_lines: pi(0, 4),
          floor_chance: p(1, 0.6),
          room_chance: p(2, 0.1),
          room_min_size: pi(3, 3),
          room_max_size: pi(4, 5),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    68 => {
      let r = @delaunay.generate(
        {
          width,
          height,
          num_points: pi(0, 15),
          room_min_size: pi(1, 3),
          room_max_size: pi(2, 6),
          corridor_width: pi(3, 1),
          extra_edge_chance: p(4, 0.15),
        },
        rng,
      )
      finish(r.grid, r.rooms.length())
    }
    _ => {
      let grid = @types.Grid2D::make(width, height, @types.Wall)
      finish(grid, 0)
    }
  }
}

///|
fn main {
  js_export_generate(dispatch)
}
