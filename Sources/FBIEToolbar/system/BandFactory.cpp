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

#include "StdAfx.h"
#include "BandFactory.h"


#include "ClassIds.h"

#include "ObjectsServer.h"

#include "../sidebar/IESidebar.h"
#include "../toolbar/IEToolbar.h"


namespace facebook{

// ---------------------------------------------------------------------
// class BandFactory
// ---------------------------------------------------------------------

BandFactory::BandFactory(const CLSID& classId):
  classId_(classId),
  objRefsCount_(0) {
  ObjectsServer::lock();
}


BandFactory::~BandFactory() {
  ObjectsServer::unlock();
}


STDMETHODIMP_(DWORD) BandFactory::AddRef() {
  return ++objRefsCount_;
}


STDMETHODIMP_(DWORD) BandFactory::Release() {
   if (--objRefsCount_ == 0) {
      delete this;
      return 0;
   }

   return objRefsCount_;
}


STDMETHODIMP BandFactory::QueryInterface(REFIID interfaceID,
      LPVOID* interfacePointer) {
   *interfacePointer = 0;

  if (IsEqualIID(IID_IUnknown, interfaceID)) {
    *interfacePointer = static_cast<IUnknown*>(this);
  } else if (IsEqualIID(IID_IClassFactory, interfaceID)) {
    *interfacePointer = static_cast<IClassFactory*>(this);
  }

  if (*interfacePointer) {
    (*reinterpret_cast<LPUNKNOWN*>(interfacePointer))->AddRef();
    return S_OK;
  }
  return E_NOINTERFACE;
}


STDMETHODIMP BandFactory::CreateInstance(LPUNKNOWN agregate,
      REFIID interfaceId, LPVOID* interfacePtr) {
   *interfacePtr = 0;

  if (agregate) {
    return CLASS_E_NOAGGREGATION;
  }

  std::auto_ptr<IDeskBand> bandInterface;

  if (IsEqualCLSID(classId_, CLSID_IEToolbar)) {
    bandInterface.reset(new IEToolbar());
  } else if (IsEqualCLSID(classId_, CLSID_IESidebar)) {
    bandInterface.reset(new IESidebar());
  }

  if (bandInterface.get()) {
    const HRESULT queryInterfaceResult =
          bandInterface->QueryInterface(interfaceId, interfacePtr);
    if (FAILED(queryInterfaceResult)) {
       return queryInterfaceResult;
    }
    bandInterface.release();
  }

  return S_OK;
}


STDMETHODIMP BandFactory::LockServer(BOOL) {
  return ObjectsServer::lock();
}

}// !namespace facebook