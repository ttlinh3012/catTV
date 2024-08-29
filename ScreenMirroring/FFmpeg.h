//
//  FFmpeg.h
//  ScreenMirroring
//
//  Created by Nguyễn Anh Tú on 30/05/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFmpeg : NSObject

/* method declaration */
- (NSString*) convertFile:( NSString* )inputPath;

@end

NS_ASSUME_NONNULL_END
