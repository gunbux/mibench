#!/bin/bash

# Set the path to FlameGraph scripts
# FLAMEGRAPH_DIR="../FlameGraph"  # Update this path to where FlameGraph is located

OUTPUT_DIR="../flamegraph_data"
mkdir -p $OUTPUT_DIR

export PLATFORM="linux"

generate_flamegraph () {
    workload_name=$1
    command_to_run=$2

    echo "Recording performance data for $workload_name"
    perf record -F 99 -a -g --output=$OUTPUT_DIR/${workload_name}_perf.data $command_to_run

    echo "Generating flame graph for $workload_name"
    perf script -i $OUTPUT_DIR/${workload_name}_perf.data | stackcollapse-perf.pl > $OUTPUT_DIR/${workload_name}_out.folded
    flamegraph.pl --colors hot --minwidth 0.5 --hash --width 1800 --inverted $OUTPUT_DIR/${workload_name}_out.folded > $OUTPUT_DIR/${workload_name}_flamegraph.svg

    echo "Flame graph generated at $OUTPUT_DIR/${workload_name}_flamegraph.svg"
}

export BASICMATH_RUNS=20
generate_flamegraph "basicmath" "./run_basicmath.sh"
export BITCOUNT_INPUT=140000000
generate_flamegraph "bitcount" "./run_bitcount.sh"
generate_flamegraph "qsort_small" "./run_qsort_small.sh"
generate_flamegraph "qsort_large" "./run_qsort_large.sh"
generate_flamegraph "susan" "./run_susan.sh"
generate_flamegraph "jpeg" "./run_jpeg.sh"
generate_flamegraph "typeset" "./run_typeset.sh"
generate_flamegraph "dijkstra" "./run_dijkstra.sh"
generate_flamegraph "patricia" "./run_patricia.sh"
export STRINGSEARCH_RUNS=5500
generate_flamegraph "stringsearch" "./run_stringsearch.sh"
generate_flamegraph "blowfish" "./run_blowfish.sh"
generate_flamegraph "sha" "./run_sha.sh"
generate_flamegraph "crc" "./run_crc.sh"
export FFT_WAVES=2048
export FFT_LENGTH=32768
generate_flamegraph "fft" "./run_fft.sh"
generate_flamegraph "adpcm" "./run_adpcm.sh"
generate_flamegraph "gsm" "./run_gsm.sh"

echo "All flame graphs generated in $OUTPUT_DIR"
