#!/bin/bash

# Input Parameters
JMX_FILE="pos.jmx"
OUTPUT_DIR="test_report"
NUM_THREADS=${1:-300}  # Default to 300 users
RAMP_TIME=${2:-10}     # Default to 10 seconds
LOOPS=${3:-1}          # Default to 1 iteration
JMETER_DIR="apache-jmeter-5.6.3"
JMETER_BIN="$JMETER_DIR/bin/jmeter"

# Verify JMeter Installation
if [ ! -d "$JMETER_DIR" ]; then
  echo "JMeter directory '$JMETER_DIR' not found. Downloading JMeter..."
  wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.6.3.zip
  unzip apache-jmeter-5.6.3.zip
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download or extract JMeter."
    exit 1
  fi
fi

# Verify JMeter Binary
if [ ! -f "$JMETER_BIN" ]; then
  echo "Error: JMeter binary not found at '$JMETER_BIN'."
  exit 1
fi

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
$JMETER_BIN -n -t $JMX_FILE \
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
