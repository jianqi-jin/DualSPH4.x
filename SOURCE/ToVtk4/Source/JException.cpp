
#include "JException.h"
#include "Functions.h"
#include <cstdio>

//==============================================================================
/// Constructor.
/// \param classname Name of the class that throws the exception.
/// \param method Name of the method that throws the exception.
/// \param text Text of the exception.
/// \param file Name of the file related to the exception.
//==============================================================================
JException::JException(const std::string &classname,const std::string &method,const std::string &text,const std::string &file){
  ExName="JException";
  ClassName=classname;
  Method=method;
  Text=text;
  File=file;
}

//==============================================================================
/// Returns the complete text message with the information of the exception. 
//==============================================================================
std::string JException::ToStr()const{
  std::string tx;
  tx=fun::PrintStr("Exception (%s::%s)\n",ClassName.c_str(),Method.c_str());
  if(!Text.empty())tx=tx+fun::PrintStr("Text: %s\n",Text.c_str());
  if(!File.empty())tx=tx+fun::PrintStr("File: %s\n",File.c_str());
  return(tx);
}

//==============================================================================
/// Visualises the exception message in console.
//==============================================================================
void JException::Print()const{
  printf("\n*** %s\n",ToStr().c_str());
}




