#import "Basic";
#import "Windows";
#import "PCG";
#import "Machine_X64";

//the #expand keyword makes this a macro it tells the compiler insert this text including the resolved code block at compile time.
//macro syntax in jai is just the normal language syntax.
timer_macro :: (code : Code) -> s64 #expand {
	begin_counter, end_counter, perf_frequency : s64;
	begin_cycle_count, end_cycle_count : u64;
	QueryPerformanceCounter(*begin_counter);
	QueryPerformanceFrequency(*perf_frequency);
	begin_cycle_count = rdtsc();
	
#insert code;
	
	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * (end_counter - begin_counter)) / perf_frequency;
	
	print("Time : %ms, MegaCycles : %\n", elapsed_time, elasped_cycles / (1000*1000));
	return elapsed_time;
}

Point :: struct {
	x : float32;
	y : float32;
}

Circle :: struct {
	using p : Point; //I wouldn't normally do this but I wanted to show the using keyword...
	r : float32;
}

/* - I could, instead, have written the below. But with using I can refer to the point directly with some_circle.p and can pass Circles to functions that would take Points
   - It's really just context for the compiler and convenience for me. There's no real use case for this here I'm just having fun.
Circle :: struct {
	x : float32;
	y : float32;
	r : float32;
}
*/

Generate_Points :: (points : []Point)
{
	for *points {
		it.x = cast(float32)random_get_within_bound(500);
		it.y = cast(float32)random_get_within_bound(500);
	}
}

Generate_Circles :: (circles : []Circle)
{
	for *circles {
		it.x = cast(float32)random_get_within_bound(500);//this line works because of the "using" keyword in line 32. I can access the members of Point directly
		it.y = cast(float32)random_get_within_bound(500);
		it.r = cast(float32)(random_get_within_bound(499)+1);
	}
}

//unnecessary function imo - probably just remove this and inline the code.
Test_Collision :: (c : Circle, p : Point) -> bool
{
	x_delta := c.x - p.x;
	y_delta := c.y - p.y;
	return (c.r * c.r) >= (x_delta * x_delta) + (y_delta * y_delta);
}

Get_Point_Collision_Counts :: (points : []Point, circles : []Circle, results : []u32)
{
	for c : circles {
		i := it_index;
		for p : points {
			if Test_Collision(c, p) results[i] += 1;
		}
	}
}

main :: ()
{
	points : []Point = NewArray(1000, Point);
	circles : []Circle = NewArray(500, Circle);
	results : []u32 = NewArray(500, u32);
	
	Generate_Points(points);
	Generate_Circles(circles);
	
	defer array_free(points);
	defer array_free(circles);
	defer array_free(results);
	
	elapsed_time_ms := timer_macro(Get_Point_Collision_Counts(points, circles, results));
	print("%\n", results);
	print("Elapsed Time : %\n", elapsed_time_ms);
}
