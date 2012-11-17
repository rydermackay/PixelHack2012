//
//  PXHAudio.h
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef struct {
	AudioUnit rioUnit;
	AudioStreamBasicDescription asbd;
	float sineFrequency;
	float sinePhase;
} EffectState;

@interface PXHAudio : NSObject

+ (PXHAudio *)sharedInstance;
- (void)start;
- (void)stop;
- (AudioSampleType)averageSample;
@property (nonatomic, assign) EffectState effectState;

@end
