#!/bin/bash


# "name" and "dirout" are named according to the testcase

name=CaseFloatingWavesVal
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
floatinginfo="../../EXECS/FloatingInfo4_linux64"


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


# a copy of CaseFloatingWavesVal_Flap.dat must exist in dirout
cp CaseFloatingWavesVal_Flap.dat $dirout


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
  $partvtk -dirin $dirout -savevtk $dirout/PartMoving -onlytype:-all,+moving -vars:+idp,+vel,+rhop,+press
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout/PartFloating -onlytype:-all,+floating
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout/PartFluid -onlytype:-all,+fluid -vars:+idp,+vel,+rhop,+press
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtkout -dirin $dirout -filexml $dirout/${name}.xml -savevtk $dirout/PartFluidOut -SaveResume $dirout/ResumeFluidOut
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $measuretool -dirin $dirout -points CaseFloatingWavesVal_heights.txt -onlytype:-all,+fluid -height:0.4 -savecsv $dirout/${name}_heights
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $computeforces -dirin $dirout -filexml $dirout/${name}.xml -onlymk:61 -savecsv $dirout/FloatingForce
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $floatinginfo -filexml $dirout/${name}.xml -onlymk:61 -savemotion -savedata $dirout/FloatingMotion 
  errcode=$?
fi


if [ $errcode -eq 0 ]; then
  echo All done
else
  echo Execution aborted
fi
read -n1 -r -p "Press any key to continue..." key
echo
