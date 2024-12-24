#!/bin/bash

# Input Parameters
JMX_FILE="pos.jmx"
OUTPUT_DIR="test_report"
NUM_THREADS=${1:-300}  # Default to 300 users
RAMP_TIME=${2:-10}     # Default to 10 seconds
LOOPS=${3:-1}          # Default to 1 iteration

# Verify Required Files
if [ ! -f "$JMX_FILE" ]; then
  echo "Error: JMX file '$JMX_FILE' not found."
  exit 1
fi

if [ ! -f "login_data.csv" ]; then
  echo "Error: CSV file 'login_data.csv' not found."
  exit 1
fi

# Clean and Prepare Output Directory
echo "Cleaning up previous test report..."
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

# Run JMeter Test
echo "Running JMeter test with $NUM_THREADS threads, $RAMP_TIME seconds ramp-up, and $LOOPS iterations..."
apache-jmeter-5.6.3/bin/jmeter -n -t $JMX_FILE \
  -l $OUTPUT_DIR/results.jtl \
  -e -o $OUTPUT_DIR \
  -Jnum_threads=$NUM_THREADS \
  -Jramp_time=$RAMP_TIME \
  -Jloops=$LOOPS

if [ $? -eq 0 ]; then
  echo "JMeter test completed successfully. Reports generated in $OUTPUT_DIR."
else
  echo "Error: JMeter test failed."
  exit 1
fi
