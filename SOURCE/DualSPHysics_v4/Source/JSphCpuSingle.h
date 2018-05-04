
#ifndef _JSphCpuSingle_
#define _JSphCpuSingle_

#include "Types.h"
#include "JSphCpu.h"
#include <string>

class JCellDivCpuSingle;
class JPartsLoad4;

//##############################################################################
//# JSphCpuSingle
//##############################################################################
/// \brief Defines the attributes and functions used only in Single-Core implementation.

class JSphCpuSingle : public JSphCpu
{
protected:
  JCellDivCpuSingle* CellDivSingle;
  JPartsLoad4* PartsLoaded;

  llong GetAllocMemoryCpu() const;
  void UpdateMaxValues();
  void LoadConfig(JCfgRun *cfg);
  void LoadCaseParticles();
  void ConfigDomain();

  void ResizeParticlesSize(unsigned newsize,float oversize,bool updatedivide);
  unsigned PeriodicMakeList(unsigned n,unsigned pini,bool stable,unsigned nmax,tdouble3 perinc,const tdouble3 *pos,const word *code,unsigned *listp)const;
  void PeriodicDuplicatePos(unsigned pnew,unsigned pcopy,bool inverse,double dx,double dy,double dz,tuint3 cellmax,tdouble3 *pos,unsigned *dcell)const;
  void PeriodicDuplicateVerlet(unsigned n,unsigned pini,tuint3 cellmax,tdouble3 perinc,const unsigned *listp
    ,unsigned *idp,word *code,unsigned *dcell,tdouble3 *pos,tfloat4 *velrhop,tsymatrix3f *spstau,tfloat4 *velrhopm1)const;
  void PeriodicDuplicateSymplectic(unsigned n,unsigned pini,tuint3 cellmax,tdouble3 perinc,const unsigned *listp
    ,unsigned *idp,word *code,unsigned *dcell,tdouble3 *pos,tfloat4 *velrhop,tsymatrix3f *spstau,tdouble3 *pospre,tfloat4 *velrhoppre)const;
  void RunPeriodic();

  void RunCellDivide(bool updateperiodic);

  inline void GetInteractionCells(unsigned rcell
    ,int hdiv,const tint4 &nc,const tint3 &cellzero
    ,int &cxini,int &cxfin,int &yini,int &yfin,int &zini,int &zfin)const;

  void Interaction_Forces(TpInter tinter);
  
  double ComputeAceMaxSeq(const bool checkcodenormal,unsigned np,const tfloat3* ace,const word* code)const;
  double ComputeAceMaxOmp(const bool checkcodenormal,unsigned np,const tfloat3* ace,const word* code)const;
  
  double ComputeStep(){ return(TStep==STEP_Verlet? ComputeStep_Ver(): ComputeStep_Sym()); }
  double ComputeStep_Ver();
  double ComputeStep_Sym();

  inline tfloat3 FtPeriodicDist(const tdouble3 &pos,const tdouble3 &center,float radius)const;
  void FtCalcForces(StFtoForces *ftoforces)const;
  void RunFloating(double dt,bool predictor);
  
  void SaveData();
  void FinishRun(bool stop);

public:
  JSphCpuSingle();
  ~JSphCpuSingle();
  void Run(std::string appname,JCfgRun *cfg,JLog2 *log);

};

#endif
