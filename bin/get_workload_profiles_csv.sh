#!/bin/bash

PERF_COMMAND="perf stat -e branch-instructions,branch-misses,cache-misses,cache-references,cpu-cycles,instructions,stalled-cycles-frontend,alignment-faults,cgroup-switches,context-switches,cpu-clock,cpu-migrations,major-faults,minor-faults,page-faults,task-clock,duration_time,user_time,system_time,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-prefetches,L1-icache-loads,L1-icache-load-misses,dTLB-loads,dTLB-load-misses,iTLB-loads,iTLB-load-misses,branch-loads,branch-loads-misses -x ,"

OUTPUT_DIR="../perf_reports"
mkdir -p $OUTPUT_DIR

export PLATFORM="linux"

# perf redirects to stderr by default
# We are using the input generation commands as specified in the Makefile
echo "Running basicmath"
export BASICMATH_RUNS=20
$PERF_COMMAND -o $OUTPUT_DIR/basicmath_perf.csv ./run_basicmath.sh

echo "Running bitcount"
export BITCOUNT_INPUT=140000000
$PERF_COMMAND -o $OUTPUT_DIR/bitcount_perf.csv ./run_bitcount.sh

echo "Running qsort small"
python ../input_generation/generate_qsort_small_input.py 9500000
$PERF_COMMAND -o $OUTPUT_DIR/qsort_small_perf.csv ./run_qsort_small.sh

echo "Running qsort large"
python ../input_generation/generate_qsort_large_input.py 10000000
$PERF_COMMAND -o $OUTPUT_DIR/qsort_large_perf.csv ./run_qsort_large.sh

echo "Running susan"
python ../input_generation/generate_susan_input.py 2500 2500
$PERF_COMMAND -o $OUTPUT_DIR/susan_perf.csv ./run_susan.sh

echo "Running jpeg"
python ../input_generation/generate_jpeg_input.py 6500 6500
$PERF_COMMAND -o $OUTPUT_DIR/jpeg_perf.csv ./run_jpeg.sh

# echo "Running lame"
# python ../input_generation/generate_lame_input.py 700
# $PERF_COMMAND ./run_lame.sh 2> lame_perf

echo "Running typeset"
python ../input_generation/generate_typeset_input.py 7000000
$PERF_COMMAND -o $OUTPUT_DIR/typeset_perf.csv ./run_typeset.sh

echo "Running dijkstra"
python ../input_generation/generate_dijkstra_input.py 2000
$PERF_COMMAND -o $OUTPUT_DIR/dijkstra_perf.csv ./run_dijkstra.sh

echo "Running patricia"
python ../input_generation/generate_patricia_input.py 2000 5500
$PERF_COMMAND -o $OUTPUT_DIR/patricia_perf.csv ./run_patricia.sh

echo "Running stringsearch"
export STRINGSEARCH_RUNS=5500
$PERF_COMMAND -o $OUTPUT_DIR/stringsearch_perf.csv ./run_stringsearch.sh

echo "Running blowfish"
python ../input_generation/generate_blowfish_input.py 120000000
$PERF_COMMAND -o $OUTPUT_DIR/blowfish_perf.csv ./run_blowfish.sh

echo "Running sha"
python ../input_generation/generate_sha_input.py 1100000000
$PERF_COMMAND -o $OUTPUT_DIR/sha_perf.csv ./run_sha.sh

echo "Running crc"
python ../input_generation/generate_crc_input.py 1200000000
$PERF_COMMAND -o $OUTPUT_DIR/crc_perf.csv ./run_crc.sh

echo "Running FFT"
export FFT_WAVES=2048
export FFT_LENGTH=32768
$PERF_COMMAND -o $OUTPUT_DIR/fft_perf.csv ./run_fft.sh

echo "Running adpcm"
python ../input_generation/generate_adpcm_input.py 300000000
$PERF_COMMAND -o $OUTPUT_DIR/adpcm_perf.csv ./run_adpcm.sh

echo "Running gsm"
python ../input_generation/generate_gsm_input.py 51000000
$PERF_COMMAND -o $OUTPUT_DIR/gsm_perf.csv ./run_gsm.sh
