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

#ifndef LOCALEUTILS_H
#define LOCALEUTILS_H

#include <map>
#include "../util/StringUtils.h"

namespace facebook {

/**
 * Class store language and country name pairs
 */
class LocaleChart {

public:
  /**
   * Class constructor
   * @param langName language name
   * @param shortLocale short locale format (language-country)
   */
  LocaleChart(const String langName, const String shortLocale) {
    this->langName_ = langName;
    this->shortLocale_ = shortLocale;
  }

  /**
   * Copy constructor for correct strings copy
   * @param instance LocaleChart instance
   */
  LocaleChart(const LocaleChart& instance) {
    *this = instance;
  }

  ~LocaleChart() {};
 
  /**
   * Get language name
   * @return language name
   */
  String getLangName() {
    return langName_;
  }

  /**
   * Get short locale format
   * @return short locale format
   */
  String getShortLocale() {
    return shortLocale_;
  }

  /**
   * Overloaded operator for correct strings copy
   * @param instance LocaleChart instance
   */
  const LocaleChart& operator= (const LocaleChart& rhs) {
    if (this != &rhs) {
      langName_ = rhs.langName_;
      shortLocale_ = rhs.shortLocale_;
    }

    return *this;
  }

public:
  LocaleChart() {}

private:
  String langName_;
  String shortLocale_;
};

typedef std::map<int, LocaleChart> LocaleMap;
typedef std::map<int, LocaleChart>::iterator LocaleIterator;

/**
 * Returns Language - Country/Region format from localeId
 * @param localeId localeId for language transform
 */
String localeIdToShortLocale(int localeId);

/**
 * Returns localeId from registry
 * @param locale_ locale mapping
 * @return localeId
 */
int localeIdFromRegistry(LocaleMap& locale);

} // !namespace facebook

#endif // LOCALEUTILS_H
