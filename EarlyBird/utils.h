//
//  utils.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#ifndef UTILS_H
#define UTILS_H

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [%d]: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...) do{}while(0)
#endif

#endif //UTILS_H
