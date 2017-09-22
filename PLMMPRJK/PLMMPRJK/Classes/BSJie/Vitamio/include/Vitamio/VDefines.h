//
//  VDefines.h
//  Vitamio
//
//  Created by erlz nuo on 7/16/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#ifndef VITAMIO_VDEFINES_H
#define VITAMIO_VDEFINES_H


#define VU_STRINGIFY(s)         	VU_TOSTRING(s)
#define VU_TOSTRING(s) 				#s
#define VU_VERSION_INT(a, b, c)		(a<<16 | b<<8 | c)
#define VU_VERSION_DOT(a, b, c) 	a ##.## b ##.## c
#define VU_VERSION(a, b, c) 		VU_VERSION_DOT(a, b, c)


#define VITAMIO_VERSION_MAJOR 	4
#define VITAMIO_VERSION_MINOR 	2
#define VITAMIO_VERSION_MICRO 	0

#define VITAMIO_VERSION_INT		VU_VERSION_INT( VITAMIO_VERSION_MAJOR, \
												VITAMIO_VERSION_MINOR, \
												VITAMIO_VERSION_MICRO )
#define VITAMIO_VERSION			VU_VERSION( VITAMIO_VERSION_MAJOR, \
											VITAMIO_VERSION_MINOR, \
											VITAMIO_VERSION_MICRO )
#define VITAMIO_VERSION_STRING	VU_STRINGIFY(VITAMIO_VERSION)


#ifdef __cplusplus
#define VITAMIO_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define VITAMIO_EXTERN	    extern __attribute__((visibility ("default")))
#endif


#endif
