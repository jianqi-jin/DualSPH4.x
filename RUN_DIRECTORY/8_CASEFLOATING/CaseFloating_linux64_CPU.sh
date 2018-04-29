#!/bin/bash


# "name" and "dirout" are named according to the testcase

name=CaseFloating
dirout=${name}_out


# "executables" are renamed and called from their directory

gencase="../../EXECS/GenCase4_linux64"
dualsphysics="../../EXECS/DualSPHysics4CPU_linux64"
boundaryvtk="../../EXECS/BoundaryVTK4_linux64"
partvtk="../../EXECS/PartVTK4_linux64"
partvtkout="../../EXECS/PartVTKOut4_linux64"
measuretool="../../EXECS/MeasureTool4_linux64"
isosurface="../../EXECS/IsoSurface4_linux64"
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
  $partvtk -dirin $dirout -savevtk $dirout/PartFloating -onlytype:-all,+floating
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtkout -dirin $dirout -filexml $dirout/${name}.xml -savevtk $dirout/PartFluidOut -SaveResume $dirout/ResumeFluidOut
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $boundaryvtk -loadvtk $dirout/${name}__Dp.vtk -filexml $dirout/${name}.xml -motiondata $dirout -savevtkdata $dirout/Box -onlymk:31
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $boundaryvtk -loadvtk $dirout/${name}__Dp.vtk -filexml $dirout/${name}.xml -motiondata $dirout -savevtkdata $dirout/MotionFloating -onlymk:61 
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $boundaryvtk -loadvtk $dirout/${name}__Dp.vtk -filexml $dirout/${name}.xml -motiondata $dirout -savevtkdata $dirout/MotionPiston -onlymk:21 
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $isosurface -dirin $dirout -saveiso $dirout/Surface
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
