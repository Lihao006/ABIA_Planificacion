import re
import matplotlib.pyplot as plt
import numpy as np

# Function to parse the text file and extract m, r, and the corresponding times
def parse_results(filename):
    results = []
    
    # Updated regular expression pattern to capture m, r, and the time with or without a leading zero
    pattern = r"Average execution time for m=(\d+), r=(\d+) with \d+ problems: (\.\d+) seconds"
    
    with open(filename, 'r') as file:
        for line in file:
            match = re.search(pattern, line)
            if match:
                m = int(match.group(1))
                r = int(match.group(2))
                time = float(match.group(3))
                results.append((m, r, time))
    
    print(f"Parsed results: {results}")  # Debug: Print the parsed results
    return results

# Function to plot the results for general m, r values
def plot_results(results, filename):
    # Convert the results into a format suitable for plotting
    ms = sorted(set(m for m, r, t in results))
    rs = sorted(set(r for m, r, t in results))
    print(f"ms: {ms}")  # Debug: Print ms
    print(f"rs: {rs}")  # Debug: Print rs
    
    # Create a grid for plotting
    time_matrix = np.zeros((len(ms), len(rs)))
    
    for m, r, time in results:
        # Find the index of m and r
        m_idx = ms.index(m)
        r_idx = rs.index(r)
        print(f"Filling matrix at m_idx={m_idx}, r_idx={r_idx} with time={time}")  # Debug
        time_matrix[m_idx, r_idx] = time
    
    print(f"time_matrix: \n{time_matrix}")  # Debug: Print time matrix
    
    # Create the plot
    plt.figure(figsize=(8, 6))
    im = plt.imshow(time_matrix, aspect='auto', cmap='viridis', interpolation='nearest')

    # Labeling the axes
    plt.xticks(np.arange(len(rs)), rs)
    plt.yticks(np.arange(len(ms)), ms)
    plt.xlabel("Number of Reservations (r)")
    plt.ylabel("Number of Rooms (m)")
    
    # Colorbar for the time values
    cbar = plt.colorbar(im)
    cbar.set_label('Average Execution Time (seconds)')
    
    # Title
    plt.title("Average Execution Time for Different Problem Sizes")
    
    # Save the plot without displaying it
    plt.savefig(filename)
    plt.close()  # Close the plot to free up memory

# Function to plot the results where m = r (line plot)
def plot_m_equals_r(results, filename):
    # Filter the results where m = r
    filtered_results = [ (m, r, time) for m, r, time in results if m == r ]
    
    if not filtered_results:
        print("No data where m = r found.")
        return

    # Extract the m values (which are equal to r) and the corresponding times
    m_values = [m for m, r, time in filtered_results]
    times = [time for m, r, time in filtered_results]
    
    print(f"Filtered m values: {m_values}")  # Debug: Print m (and r) values for m = r
    print(f"Filtered times: {times}")  # Debug: Print corresponding times
    
    # Create a line plot
    plt.figure(figsize=(8, 6))
    plt.plot(m_values, times, marker='o', linestyle='-', color='b', label="Execution Time")

    # Labeling the axes
    plt.xlabel("Number of Rooms (m) = Number of Reservations (r)")
    plt.ylabel("Average Execution Time (seconds)")
    
    # Title
    plt.title("Average Execution Time for m = r")
    
    # Save the plot without displaying it
    plt.savefig(filename)
    plt.close()  # Close the plot to free up memory

# Function to plot the marginal distribution for m
def plot_marginal_m(results, filename):
    # Summing execution times for each m across all r
    ms = sorted(set(m for m, r, t in results))
    marginal_m = [sum(time for m, r, time in results if m == m_val) for m_val in ms]
    
    print(f"Marginal m values: {ms}")  # Debug: Print m values
    print(f"Marginal execution times for m: {marginal_m}")  # Debug: Print marginal times for m
    
    # Create a line plot for marginal distribution of m
    plt.figure(figsize=(8, 6))
    plt.plot(ms, marginal_m, marker='o', linestyle='-', color='r', label="Marginal Execution Time for m")
    
    # Labeling the axes
    plt.xlabel("Number of Rooms (m)")
    plt.ylabel("Total Execution Time")
    
    # Title
    plt.title("Marginal Distribution of Execution Time for m")
    
    # Save the plot without displaying it
    plt.savefig(filename)
    plt.close()  # Close the plot to free up memory

# Function to plot the marginal distribution for r
def plot_marginal_r(results, filename):
    # Summing execution times for each r across all m
    rs = sorted(set(r for m, r, t in results))
    marginal_r = [sum(time for m, r, time in results if r == r_val) for r_val in rs]
    
    print(f"Marginal r values: {rs}")  # Debug: Print r values
    print(f"Marginal execution times for r: {marginal_r}")  # Debug: Print marginal times for r
    
    # Create a line plot for marginal distribution of r
    plt.figure(figsize=(8, 6))
    plt.plot(rs, marginal_r, marker='o', linestyle='-', color='g', label="Marginal Execution Time for r")
    
    # Labeling the axes
    plt.xlabel("Number of Reservations (r)")
    plt.ylabel("Total Execution Time")
    
    # Title
    plt.title("Marginal Distribution of Execution Time for r")
    
    # Save the plot without displaying it
    plt.savefig(filename)
    plt.close()  # Close the plot to free up memory

# Parse the file and plot the results
filename = "results.txt"
results = parse_results(filename)

# Plot the general results and save the first plot
plot_results(results, "experimento4_plot_general.png")

# Plot the filtered results (where m = r) as a line plot and save the second plot
plot_m_equals_r(results, "experimento4_plot_m_equals_r_line.png")

# Plot the marginal distribution for m and save the third plot
plot_marginal_m(results, "experimento4_plot_marginal_m.png")

# Plot the marginal distribution for r and save the fourth plot
plot_marginal_r(results, "experimento4_plot_marginal_r.png")
