//
//  MyDefines.h
//  音视频学习
//
//  Created by macbook on 2020/4/1.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#ifndef MyDefines_h
#define MyDefines_h

typedef struct _NALUnit{
    unsigned int type;
    unsigned int size;
    unsigned char *data;
}NALUnit;

//typedef enum{
//    NALUTypeBPFrame = 0x01,
//    NALUTypeIFrame = 0x05,
//    NALUTypeSPS = 0x07,
//    NALUTypePPS = 0x08
//}NALUType;
#endif /* MyDefines_h */
