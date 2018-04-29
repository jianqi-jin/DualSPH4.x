#!/bin/bash


# "name" and "dirout" are named according to the testcase

name=CaseWavemaker2D
dirout=${name}_out


# "executables" are renamed and called from their directory

gencase="../../EXECS/GenCase4_linux64"
dualsphysics="../../EXECS/DualSPHysics4CPU_linux64"
boundaryvtk="../../EXECS/BoundaryVTK4_linux64"
partvtk="../../EXECS/PartVTK4_linux64"
partvtkout="../../EXECS/PartVTKOut4_linux64"
measuretool="../../EXECS/MeasureTool4_linux64"
isosurface="../../EXECS/IsoSurface4_linux64"
computeforces="../../EXECS/ComputeForces4_linux64"


# Library path must be indicated properly

current=$(pwd)
cd ../../EXECS
path_so=$(pwd)
cd $current
export LD_LIBRARY_PATH=$path_so


# "dirout" is created to store results or it is cleaned if it already exists

if [ -e $dirout ]; then
  rm -f -r $dirout
fi
mkdir $dirout


# a copy of CaseWavemaker2D_Piston_Movement.dat must exist in dirout
cp CaseWavemaker2D_Piston_Movement.dat $dirout


# CODES are executed according the selected parameters of execution in this testcase
errcode=0

if [ $errcode -eq 0 ]; then
  $gencase ${name}_Def $dirout/$name -save:all
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $dualsphysics $dirout/$name $dirout -svres -cpu
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout/PartFluid -onlytype:-all,+fluid
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout/PartMoving -onlytype:-all,+moving
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtkout -dirin $dirout -filexml $dirout/${name}.xml -savevtk $dirout/PartFluidOut -SaveResume $dirout/ResumeFluidOut
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $measuretool -dirin $dirout -points CaseWavemaker2D_wg1_2D.txt -onlytype:-all,+fluid -height -savecsv $dirout/wg1 -savevtk $dirout/wg1 
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $measuretool -dirin $dirout -points CaseWavemaker2D_wg2_2D.txt -onlytype:-all,+fluid -height -savecsv $dirout/wg2 -savevtk $dirout/wg2 
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $measuretool -dirin $dirout -points CaseWavemaker2D_wg3_2D.txt -onlytype:-all,+fluid -height -savecsv $dirout/wg3 -savevtk $dirout/wg3 
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $computeforces -dirin $dirout -filexml $dirout/${name}.xml -onlyid:1616-1669 -savecsv $dirout/WallForce
  errcode=$?
fi
# Note that initial hydrostatic force is 20.72 N (initial column water 0.065 high) 

if [ $errcode -eq 0 ]; then
  echo All done
else
  echo Execution aborted
fi
read -n1 -r -p "Press any key to continue..." key
echo
