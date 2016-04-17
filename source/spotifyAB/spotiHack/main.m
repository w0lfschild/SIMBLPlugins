//
//  main.m
//  spotiHack
//
//  Created by Wolfgang Baird on 2/5/16.
//  Copyright © 2016 Wolfgang Baird. All rights reserved.
//

#import "main.h"

struct TrackMetadata;

main *plugin;
NSUserDefaults *sharedPrefs;
NSDictionary *sharedDict;
bool enabled = true;

@implementation main

+ (main*) sharedInstance
{
    static main* plugin = nil;
    
    if (plugin == nil)
        plugin = [[main alloc] init];
    
    return plugin;
}

+ (void)load {
    plugin = [main sharedInstance];
    NSLog(@"spotiHack loaded...");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [plugin pollThread];
        dispatch_async(dispatch_get_main_queue(), ^{
            //
        });
    });
}

- (void)pollThread {
    // playerState
    // 1 playing
    // 2 paused
    usleep(10000000);
    ClientApplication *thisApp = [NSApplication sharedApplication];
    NSString *currentTrack = [[NSString alloc] init];
    NSImage *trackImage = [[NSImage alloc] init];
    NSNumber *appVolume = [thisApp soundVolume];
    bool imageFetched = false;
    bool isAD = false;
    bool isMuted = false;
    
    while (true) {
        NSNumber *playState = thisApp.playerState;
        if ([playState isEqualToNumber:[NSNumber numberWithInt:2]]) {
            [NSApp setApplicationIconImage:nil];
            [[NSApp dockTile] setBadgeLabel:nil];
            if (isMuted)
            {
                isMuted = false;
                [thisApp setSoundVolume:appVolume];
            }
        } else {
            SPAppleScriptTrack *track = [thisApp currentTrack];
            NSString *trackURL = track.spotifyURL;
            
            NSRange range = [trackURL rangeOfString:@"spotify:ad"];
            if(range.location != NSNotFound) {
                isAD = true;
            } else {
                isAD = false;
            }
            
            if (isAD)
            {
                if (!isMuted)
                {
                    isMuted = true;
                    appVolume = [thisApp soundVolume];
                    [thisApp setSoundVolume:[NSNumber numberWithInt:0]];
                    [[NSApp dockTile] setBadgeLabel:@"Muted"];
                    [NSApp setApplicationIconImage:nil];
                }
            } else {
                if (isMuted)
                {
                    isMuted = false;
                    [thisApp setSoundVolume:appVolume];
                    [[NSApp dockTile] setBadgeLabel:nil];
                }
                
                if (![currentTrack isEqualToString:trackURL])
                {
                    currentTrack = [NSString stringWithFormat:@"%@", trackURL];
                    NSString *combinedURL = [NSString stringWithFormat:@"https://embed.spotify.com/oembed/?url=%@", trackURL];
                    NSURL *targetURL = [NSURL URLWithString:combinedURL];
                    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
                    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    NSString *fixedString = [dataString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                    fixedString = [fixedString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSArray *urlComponents = [fixedString componentsSeparatedByString:@","];
                    NSString *iconURL = @"";
                    if ([urlComponents count] >= 7)
                        iconURL = [urlComponents objectAtIndex:7];
                    NSArray *iconComponents = [iconURL componentsSeparatedByString:@":"];
                    NSString *iconURLFixed = [NSString stringWithFormat:@"https:%@", [iconComponents lastObject]];
                    //        NSString *iconURLx120 = [iconURLFixed stringByReplacingOccurrencesOfString:@"cover" withString:@"120"];
                    NSLog(@"%@", iconURLFixed);
                    NSImage *myImage = [[NSImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconURLFixed]]];
                    //        NSImage *myImage = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:iconURLx60]];
                    
                    if ( myImage )
                    {
                        //                    CGImageRef imgRef = [image CGImage];
                        //                    CGImageRef maskRef = [[CIImage alloc] initWithContentsOfURL:[NSURL URLWithString:iconURLFixed]];
                        //                    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                        //                                                              CGImageGetHeight(maskRef),
                        //                                                              CGImageGetBitsPerComponent(maskRef),
                        //                                                              CGImageGetBitsPerPixel(maskRef),
                        //                                                              CGImageGetBytesPerRow(maskRef),
                        //                                                              CGImageGetDataProvider(maskRef), NULL, false);
                        //                    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
                        
                        [NSApp setApplicationIconImage:myImage];
                        trackImage = myImage;
                        imageFetched = true;
                        //            NSLog(@"Image is not null :%@", myImage);
                        //            [[myImage TIFFRepresentation] writeToFile:@"/Users/w0lf/Desktop/test.tif" atomically:YES];
                    }
                } else {
                    if (imageFetched)
                        [NSApp setApplicationIconImage:trackImage];
                }
            }
            usleep(3000000);
        }
    }
}

@end

