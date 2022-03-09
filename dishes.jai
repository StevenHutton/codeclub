#import "Basic";
#import "Windows";
#import "PCG";
#import "Machine_X64";

//timer macro - nothing new, ignore
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

//holy shit this is slow.
insertion_sort :: (array: [] $T, f: (T, T) -> int) {
    for i: 0..array.count-1 {
        value := array[i];
		
        j := i;
        while (j != 0 && f(value, array[j-1]) < 0) {
            array[j] = array[j-1];
            j -= 1;
        }
        if i != j {
            array[j] = value;
        }
    }
}

satisfaction_input1 := int.[-1, -8, -9, 5, 0];
satisfaction_input2 := int.[4, 3, 2];
satisfaction_input3 := int.[4, 3, 2, 0];
satisfaction_input4 := int.[-1, -4, -5];
satisfaction_input5 := int.[-1, -4, -5, 19, 4, 2, 1, 3, 7, -6, 8 -26];

sum_of_all_terms :: (terms : []int) -> int
{
	result := 0;
	for term : terms {
		result += term;
	}
	return result;
}

sum_of_series :: (terms : []int) -> int
{
	result := 0;
	for term : terms {
		result += term * (it_index+1);
	}
	return result;
}

solve :: (values : []int)
{
	values_local := values;
  //sort array ascending
	insertion_sort(values_local, (a,b) => a-b);
	answer_found := false;
	
	for 0..values_local.count-1 {
    //if the sum of all terms is positive then removing any more negative terms won't improve the solution.
		if sum_of_all_terms(values_local) >= 0
			break;
		
    /*remove the first term from the array-view.
      an array view is basically a struct with two fields
      count: s64;
      data : *some_type; //a pointer to the array data in memory
      we remove the first term by decrementing the count and incrementing the pointer. Easy!
    */  
		values_local.count -=1;
		values_local.data += 1;
	}
	
	print("%\n", values_local);
	print("Result %\n", sum_of_series(values_local));
}
/*
example output
[-1, 0, 5]
Result 14
[2, 3, 4]
Result 20
[0, 2, 3, 4]
Result 29
[]
Result 0
[-18, -6, -5, -4, -1, 1, 2, 3, 4, 7, 19]
Result 293
*/
main :: ()
{
	elapsed_time_ms := timer_macro(#code 
	{
		solve(satisfaction_input1);
		solve(satisfaction_input2);
		solve(satisfaction_input3);
		solve(satisfaction_input4);
		solve(satisfaction_input5);
	});

	print("Elapsed Time : %ms\n", elapsed_time_ms);
}
