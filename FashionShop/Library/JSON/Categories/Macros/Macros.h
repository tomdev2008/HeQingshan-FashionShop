//
//  Macros.h
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

// MEMORY

#if __has_feature(objc_arc)
    #define SAFE_RELEASE(obj) 
    #define SAFE_TIMER_RELEASE(obj) 
#else
    #define SAFE_RELEASE(obj) ([obj release], obj = nil)
    #define SAFE_TIMER_RELEASE(obj) ([obj invalidate], [obj release], obj = nil)
#endif

// SELECTORS

#define SEL(x) @selector(x)
#define L(key) (NSLocalizedString((key), nil))
