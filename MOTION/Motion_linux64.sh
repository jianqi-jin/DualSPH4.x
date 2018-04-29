#!/bin/bash

gencase="../EXECS/GenCase4_linux64"
boundaryvtk="../EXECS/BoundaryVTK4_linux64"
errcode=0

c=1
while [ $c -le 9 ] && [ $errcode -eq 0 ]; do
  name=Motion0$c

  if [ -e $name ]; then
    rm -f -r $name
  fi
  mkdir $name

  if [ $errcode -eq 0 ]; then
    $gencase $name $name/$name
    errcode=$?
  fi
  if [ $errcode -eq 0 ]; then
    $boundaryvtk -loadvtk $name/${name}__Actual.vtk -filexml $name/${name}.xml -savevtkdata $name/${name}.vtk
    errcode=$?
  fi

  let c=c+1
done 


if [ $errcode -eq 0 ]; then
  echo All done
else
  echo Execution aborted
fi
read -n1 -r -p "Press any key to continue..." key
echo
