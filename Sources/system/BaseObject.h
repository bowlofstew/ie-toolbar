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


#ifndef BASEOBJECT_H
#define BASEOBJECT_H

// {C38D254C-4C40-4192-A746-AC6FE519831E}
extern "C" const __declspec(selectany) IID IID_IBaseObject = 
  {0xc38d254c, 0x4c40, 0x4192,
    {0xa7, 0x46, 0xac, 0x6f, 0xe5, 0x19, 0x83, 0x1e}};

/**
 * struct IBaseObject
 *
 * Base interface for internet protocol hooks
 * Allows to add some custom methods to that system handler
 */

struct
__declspec(uuid("{C38D254C-4C40-4192-A746-AC6FE519831E}"))
__declspec(novtable)
IBaseObject : public IUnknown {

  /**
   * Sets the real object that will be targeted with all requests
   *
   * @param realTarget - pointer to that target
   */
  STDMETHOD(SetTargetUnknown)(IUnknown* realTarget) = 0;

  /**
   * Sets the window that will get the notifications
   *
   * @param window - window for notification
   */
  STDMETHOD(setTargetWindow)(HWND window) = 0;

};

#if _ATL_VER < 0x700
  #define InlineIsEqualGUID ::ATL::InlineIsEqualGUID
#else
  #define InlineIsEqualGUID ::InlineIsEqualGUID
#endif

#endif // BASEOBJECT_H
