#!/bin/bash

JMX_FILE="pos.jmx"
NUM_THREADS=${1:-300}   # Default: 300 users
RAMP_TIME=${2:-10}      # Default: 10 seconds
LOOPS=${3:-1}           # Default: 1 iteration
PROPERTIES_FILE="test.properties" # JMeter properties file

if [ ! -f "$JMX_FILE" ]; then
  echo "Error: JMX file '$JMX_FILE' not found."
  exit 1
fi

if [ ! -f "$PROPERTIES_FILE" ]; then
  echo "Error: Properties file '$PROPERTIES_FILE' not found."
  exit 1
fi

if [ ! -f "login_data.csv" ]; then
  echo "Error: CSV file 'login_data.csv' not found."
  exit 1
fi

echo "Updating properties file with parameters..."
echo "num_threads=$NUM_THREADS" > $PROPERTIES_FILE
echo "ramp_time=$RAMP_TIME" >> $PROPERTIES_FILE
echo "loops=$LOOPS" >> $PROPERTIES_FILE

if [ $? -eq 0 ]; then
  echo "Properties file updated successfully: $PROPERTIES_FILE"
else
  echo "Error: Failed to update properties file."
  exit 1
fi

echo "Updated Configuration:"
cat $PROPERTIES_FILE
