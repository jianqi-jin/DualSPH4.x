/*
<DUALSPHYSICS>  Copyright (C) 2013 by Jose M. Dominguez, Dr Alejandro Crespo, Prof. M. Gomez Gesteira, Anxo Barreiro, Ricardo Canelas
                                      Dr Benedict Rogers, Dr Stephen Longshaw, Dr Renato Vacondio

EPHYSLAB Environmental Physics Laboratory, Universidade de Vigo, Ourense, Spain.
School of Mechanical, Aerospace and Civil Engineering, University of Manchester, Manchester, U.K.

This file is part of DualSPHysics. 

DualSPHysics is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at your option) any later version. 

DualSPHysics is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. 

You should have received a copy of the GNU General Public License, along with DualSPHysics. If not, see <http://www.gnu.org/licenses/>. 
*/

/// \file JCreateVtk.h \brief Declares the class \ref JCreateVtk.

#ifndef _JCreateVtk_
#define _JCreateVtk_

#pragma warning(disable : 4996) //Cancels sprintf() deprecated.

#include <string>
#include <cstring>
#include "TypesDef.h"

//##############################################################################
//# JCreateVtk
//##############################################################################
/// \brief Provides functions to store particle data in formats VTK, CSV, ASCII.

class JCreateVtk
{
public:

  typedef enum{ UChar8,Char8,UShort16,Short16,UInt32,Int32,Float32,Double64,TpDataNull }TpData;

  /// Strucutre with the information of an array of particle data to be stored in CSV or VTK format.
  typedef struct {
    std::string name;
    TpData type;
    unsigned comp;
    void *pointer;
  }StScalarData;

  //==============================================================================
  /// Throws a simple exception.
  //==============================================================================
  static void RunException(std::string method,std::string msg);
  
  //==============================================================================
  /// Throws an exception related to a file.
  //==============================================================================  
  static void RunException(std::string method,std::string msg,std::string file);

  //==============================================================================
  /// Returns the fields definition.
  //==============================================================================
  static StScalarData DefineField(const std::string &name,TpData type,unsigned comp,void *pointer=NULL){
    StScalarData f; f.name=name; f.type=type; f.comp=comp; f.pointer=pointer;
    return(f);
  }

  //==============================================================================
  /// Checks the definition of fields.
  //==============================================================================
  static void CheckFields(unsigned nfields,const StScalarData* fields);

  //==============================================================================
  /// Stores data in VTK format.
  //============================================================================== 
  static void SaveVtk(std::string fname,unsigned np,const tfloat3* pos,unsigned nfields,const StScalarData* fields);
  
  //==============================================================================
  /// Stores data in CSV format.
  //============================================================================== 
  static void SaveCsv(std::string fname,unsigned np,const tfloat3* pos,unsigned nfields,const StScalarData* fields);

};


#endif


