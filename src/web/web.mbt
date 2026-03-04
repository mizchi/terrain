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
