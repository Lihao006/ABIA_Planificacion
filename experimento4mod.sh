METRICFF="${METRICFF:-./metricff.exe}"
NUM_PROBLEMS="${NUM_PROBLEMS:-100}"

touch "results.txt" || { echo "Cannot create results.txt"; exit 1; }
chmod u+rw results.txt || { echo "Cannot set permissions for results.txt"; exit 1; }

# Loop over multiple values for m and r (from 2 to 20)
for m in $(seq 2 2 20); do
  for r in $(seq 2 2 20); do
    echo "Testing for m=$m, r=$r..."

    # Generate problems with current m and r
    output_dir="problemas_hotel_${m}_${r}"
    python3 generador.py $NUM_PROBLEMS Hoteldomain4 -m $m -r $r --out "$output_dir"

    # auto-use Wine for Windows .exe on Linux/macOS
    OS="$(uname)"
    RUN_CMD="$METRICFF"
    if [[ "$OS" != "MINGW"* && "$OS" != "CYGWIN"* && "$METRICFF" == *.exe ]]; then
        if command -v wine >/dev/null 2>&1; then
            RUN_CMD="wine $METRICFF"
        else
            echo "Warning: $METRICFF is a Windows .exe but Wine not found."
        fi
    fi

    # Initialize variables for total time and number of problems
    total_time=0.0

    # Loop through each generated problem (problema_1.pddl to problema_100.pddl)
    for i in $(seq 1 $NUM_PROBLEMS); do
        # Capture the execution time of each run and accumulate the total time
        problem_file="$output_dir/problema_${i}.pddl"
        
        # Run metricff and capture real time
        exec_time=$( { time $RUN_CMD -o Hoteldomain4.pddl -f "$problem_file" > /dev/null 2>&1; } 2>&1 | grep real | awk '{print $2}' | sed 's/m//;s/s//' )    

        # Add the execution time to the total time
        total_time=$(echo "$total_time + $exec_time" | bc)
        
        echo "Problem $i executed in $exec_time seconds."
    done

    # Calculate average execution time
    average_time=$(echo "scale=3; $total_time / $NUM_PROBLEMS" | bc)

    # Save the average time to the results file
    echo "Average execution time for m=$m, r=$r with $NUM_PROBLEMS problems: $average_time seconds" >> results.txt
    echo "Average time for m=$m, r=$r: $average_time seconds"

    # Remove the folder with the generated problems
    rm -rf "$output_dir"
    echo "Removed folder: $output_dir"

  done  # End of 'r' loop
done  # End of 'm' loop

echo "All tests complete. Results saved in results.txt"
