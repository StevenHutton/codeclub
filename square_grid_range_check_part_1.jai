	height : s32;
}

set_up_grid :: (using grid : Grid, impassable_chance : float32)
{
	assert(impassable_chance <= 1.0 && impassable_chance >= 0.0);
	
	for *point : tiles {
		count := cast(s32)it_index;
		point.x = count % width;
		point.y = count / width;
		point.passable = random_get_zero_to_one() > impassable_chance;//chance to be impassable
	}
}

//this one is longer and probably slower but maybe it's easier to understand?
set_up_grid_2 :: (using grid : Grid, impassable_chance : float32)
{
	assert(impassable_chance <= 1.0 && impassable_chance >= 0.0);
	
	for 0..height-1 {
		y := cast(s32)it;
		for 0..width-1 {
			x := cast(s32)it;
			count := (width*y)+x;
			tiles[count].x = x;
			tiles[count].y = y;
			tiles[count].passable = random_get_zero_to_one() > impassable_chance;//chance to be impassable
		}
	}
}

get_random_passable_point :: (using grid : Grid) -> Point
{
	p : Point;	
	found := false;
	
	while !found {
		p.x = cast(s32)random_get_within_bound(xx (width-1));
		p.y = cast(s32)random_get_within_bound(xx (height-1));
		
		if tiles[(p.y*width)+p.x].passable {
			found = true;
		}
	}
	
	return p;
}

get_tile_at :: (using grid : Grid, x : s32, y : s32) -> Tile
{
	return tiles[(y*width)+x];
}

main :: ()
{
	grid : Grid;
	grid.width = cast(s32)random_get_within_bound(98)+2;
	grid.height = cast(s32)random_get_within_bound(98)+2;
	
	//you can also use "using" inside a scope, like this.
	using grid;
	
	tiles = NewArray(width * height, Tile);
	defer array_free(tiles);
	
	set_up_grid(grid, 0.1);
	
	start_point := get_random_passable_point(grid);
	end_point := get_random_passable_point(grid);
	
	
}
