//
//  DNARCCompatible.h
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/17/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#ifndef DNARC_COMPATIBLE_H_
#define DNARC_COMPATIBLE_H_

//strong OR retain
#ifndef DN_ATTSTRONG

#if __has_feature(objc_arc)

#define DN_ATTSTRONG strong

#else

#define DN_ATTSTRONG retain

#endif

#endif


//weak OR assign
#ifndef DN_ATTWEAK

#if __has_feature(objc_arc_weak)

#define DN_ATTWEAK weak

#elif __has_feature(objc_arc)

#define DN_ATTWEAK unsafe_unretained

#else

#define DN_ATTWEAK assign

#endif

#endif


//release
#if __has_feature(objc_arc)

#define DN_AUTORELEASE(expression)

#define DN_RELEASE(expression)

#define DN_RETAIN(expression) expression

#else

#define DN_AUTORELEASE(expression) [expression autorelease]

#define DN_RELEASE(expression) [expression release]

#define DN_RETAIN(expression) [expression retain]

#endif

#endif