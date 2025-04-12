#!/bin/bash

# Load the variables from the other script
source ./other_script.sh

# Use the variables from the other script
echo "The value of VARIABLE1 is: $VARIABLE1"
echo "The value of VARIABLE2 is: $VARIABLE2"

# Perform some other actions using the variables
if [ "$VARIABLE1" == "value1" ]; then
    echo "VARIABLE1 is equal to value1"
else
    echo "VARIABLE1 is not equal to value1"
fi
