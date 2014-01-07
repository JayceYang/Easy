//
//  Macro.h
//  Easy
//
//  Created by Jayce Yang on 13-12-13.
//  Copyright (c) 2013年 Jayce Yang. All rights reserved.
//

#ifndef Easy_Macro_h
#define Easy_Macro_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [LINE %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif
