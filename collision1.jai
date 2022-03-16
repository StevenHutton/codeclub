#import "Basic";
#import "Windows";
#import "Machine_X64";
#import "Math";

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
	
	print("Time : %ms, MegaCycles : %, Cycles : %\n", elapsed_time, elasped_cycles / (1000*1000), elasped_cycles);
	return elapsed_time;
}

rect :: struct {
	using pos : Vector2;
	width, height : float32;
}

epsilon :: 0.001;
is_collision :: (r1 : rect, r2 : rect) -> bool
{
	offset := r1.pos - r2.pos;
	offset_abs := abs(offset);
	
	w := r1.width / 2 + r2.width / 2;
	h := r1.height / 2 + r2.height / 2;
	
	if ((w - offset_abs.x) > epsilon) && ((h - offset_abs.y) > epsilon)
	{		
		return true;
	}
	
	return false;
}

main :: ()
{
	a, b : rect;
	a.pos.x = 0.0;
	a.pos.y = 0.0;
	a.width = 2.0;
	a.height = 2.0;
		
	b.pos.x = 2.0;
	b.pos.y = 1.0;
	b.width = 2.0;
	b.height = 2.0;
	
	elapsed_time_ms := timer_macro(#code 
	{
		print("%\n", is_collision(a,b));
	});

	print("Elapsed Time : %ms\n", elapsed_time_ms);
}
