/**
* Facebook Internet Explorer Toolbar Software License 
* Copyright (c) 2009 Facebook, Inc. 
*
* Permission is hereby granted, free of charge, to any person or organization
* obtaining a copy of the software and accompanying documentation covered by
* this license (which, together with any graphical images included with such
* software, are collectively referred to below as the "Software") to (a) use,
* reproduce, display, distribute, execute, and transmit the Software, (b)
* prepare derivative works of the Software (excluding any graphical images
* included with the Software, which may not be modified or altered), and (c)
* permit third-parties to whom the Software is furnished to do so, all
* subject to the following:
*
* The copyright notices in the Software and this entire statement, including
* the above license grant, this restriction and the following disclaimer,
* must be included in all copies of the Software, in whole or in part, and
* all derivative works of the Software, unless such copies or derivative
* works are solely in the form of machine-executable object code generated by
* a source language processor.  
*
* Facebook, Inc. retains ownership of the Software and all associated
* intellectual property rights.  All rights not expressly granted in this
* license are reserved by Facebook, Inc.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
* SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
* FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
* DEALINGS IN THE SOFTWARE.
*/ 

#ifndef SHELLUTILS_H
#define SHELLUTILS_H

#include <vector>
#include "StringUtils.h"

namespace facebook{

 /**
  * Gets current application data directory
  *
  * @return path to the data directory
  */
 String getApplicationDataDir();


 /**
  * Gets the list of folder files by mask
  *
  * @param folder where to search files
  * @param mask chick will be applied to search files
  * @return path to the data directory
  */
 std::vector<String> getFileList(const String& folder, const String& mask);

 /**
  * Execute the file with parameters
  *
  * @param executeFile - file to execute
  * @param parameters optional command line parameters
  * @return true if suceeded
  */
 bool execute(String executeFile, String parameters);

 /**
  * Terminate processes
  *
  * @param processName - process to terminate
  * @return true if suceeded
  */
 bool terminateAllProcesses(const String& processName);

 /**
  * Determine if LCID is bidirectional
  * @param localeId LCID of the locale
  * @return true if locale is bidirectional, false - otherwise
  */
 bool isBiDi(int localeId);

} // !namespace facebook


#endif // SHELLUTILS_H
