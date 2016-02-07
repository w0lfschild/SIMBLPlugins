//
//  main.h
//  spotiHack
//
//  Created by Wolfgang Baird on 2/5/16.
//  Copyright © 2016 Wolfgang Baird. All rights reserved.
//

@import AppKit;

@interface main : NSObject

@end

@interface ClientApplication : NSApplication
{
    
}

- (void)setShuffle:(BOOL)arg1;
- (BOOL)shuffle;
- (BOOL)shuffleEnabled;
- (void)setRepeat:(BOOL)arg1;
- (BOOL)repeat;
- (BOOL)repeatEnabled;
- (void)setPlaybackPosition:(id)arg1;
- (id)playbackPosition;
- (id)playerState;
- (void)setSoundVolume:(id)arg1;
- (id)soundVolume;
- (id)currentTrack;

@end

@interface SPAppleScriptItem : NSObject
{
    id parentItem;
    NSString *key;
}

- (void)dealloc;
- (id)objectSpecifier;
- (id)description;
- (id)title;
- (id)applescriptID;
- (id)initWithKey:(id)arg1 inParent:(id)arg2;

@end

@interface SPAppleScriptTrack : SPAppleScriptItem
{
}

- (void)dealloc;
- (id)cover;
- (id)spotifyURL;
- (id)popularity;
- (id)trackNumber;
- (id)playCount;
- (id)duration;
- (id)discNumber;
- (id)applescriptID;
- (id)title;
- (id)albumArtist;
- (id)album;
- (id)artist;

@end