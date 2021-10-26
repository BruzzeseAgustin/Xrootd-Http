#!/bin/bash


while true
do  
  su datatrans -c "python /file_simulator.py symb"
  # su datatrans -c "python /file_simulator.py update" 
  sleep 3600

done
