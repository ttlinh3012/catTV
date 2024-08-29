//
//  FFmpeg.m
//  ScreenMirroring
//
//  Created by Nguyễn Anh Tú on 30/05/2022.
//

#import <Foundation/Foundation.h>
#import "FFmpeg.h"
#include <ffmpegkit/FFmpegKit.h>
#include <FCFileManager.h>


@implementation FFmpeg

- (NSString*) convertFile:( NSString* )inputPath {
    
    NSString *pathTemp = [FCFileManager pathForDocumentsDirectory];

    NSString *command = [NSString stringWithFormat:@"-i %@ -codec: copy -start_number 0 -hls_time 10 -hls_list_size 0 -f hls %@/video.m3u8", inputPath, pathTemp];

    FFmpegSession *session = [FFmpegKit execute: command];
    ReturnCode *returnCode = [session getReturnCode];
    if ([ReturnCode isSuccess:returnCode]) {
        // SUCCESS
//        NSArray* listFiles = [FCFileManager listFilesInDirectoryAtPath:pathTemp];
//        NSLog(@"ten file trong tmp %@", listFiles);

        return [NSString stringWithFormat:@"%@/video.m3u8", pathTemp];

    } else if ([ReturnCode isCancel:returnCode]) {
        // CANCEL
        return @"";
    } else {
        // FAILURE
        NSLog(@"Command failed with state %@ and rc %@.%@", [FFmpegKitConfig sessionStateToString:[session getState]], returnCode, [session getFailStackTrace]);
        return @"";
    }
}

@end
