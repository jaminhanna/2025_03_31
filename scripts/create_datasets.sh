#!/bin/sh
#SBATCH --account=ISAAC-UTK0319
#SBATCH --partition=campus
#SBATCH --qos=campus
#SBATCH --nodes=6
#SBATCH --ntasks=288
#SBATCH --time=24:00:00
#SBATCH --output=j.out
#SBATCH --error=j.err

for i in train-*-frames.txt
do
  for ((j=50; j<=250; j=$((j+10))))
  do
    df=`echo $i | sed "s/frames.txt/threshold-$j-data.txt/"`
    lf=`echo $i | sed "s/frames.txt/threshold-$j-label.txt/"`
    case $i in
    train-0-*) bf=bboxes/train-0-bboxes.txt ;;
    train-1-*) bf=bboxes/train-1-bboxes.txt ;;
    train-2-*) bf=bboxes/train-2-bboxes.txt ;;
    esac
    echo "ADD_FILES $i $bf
SET_ROWS 31
SET_COLS 39
SET_THRESHOLD $j
SET_BAD_FRAME_THRESHOLD 3000
SET_SELECTION_TYPE random
SET_SEED 1
CREATE_DATASET
WRITE $df $lf" | $repos/2026-fred-dataset/bin/create_dataset &
  done
done
wait
