
#ifndef _JCfgRun_
#define _JCfgRun_

#pragma warning(disable : 4996) //Anula sprintf() deprecated.

#include "TypesDef.h"
#include "Functions.h"
#include "JObject.h"

#include <string>
#include <cstring>
#include <sstream>
#include <iostream>
#include <fstream>
#include <cstdlib>

//##############################################################################
//# JCfgRun
//##############################################################################
/// \brief Defines the class responsible of collecting the execution parameters by command line.

class JCfgRun : protected JObject
{
protected:
  int ParmDef;

public:
  bool PrintInfo;

  std::string DirIn;
  std::string FileIn;
  std::string FileXml;

  int First,Last;

  std::string SaveVtk;
  std::string SaveCsv;
  
public:
  void ClearFilesIn(){ DirIn=""; FileIn=""; }

public:
  JCfgRun();
  void Reset();
  void VisuInfo()const;
  void VisuConfig()const;
  void PrintConfig(const std::string& tx)const;
  void LoadArgv(int argc,char** argv);
  void LoadFile(std::string fname,int lv);
  void LoadOpts(std::string *optlis,int optn,int lv,std::string file);
  void ErrorParm(const std::string &opt,int optc,int lv,const std::string &file)const;
  bool VtuOptGet(std::string name);
  void ValidaCfg();
};

#endif

