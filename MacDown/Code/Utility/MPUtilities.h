//
//  MPUtilities.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 8/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMPStylesDirectoryName;
extern NSString * const kMPStyleFileExtension;
extern NSString * const kMPThemesDirectoryName;
extern NSString * const kMPThemeFileExtension;

NSString *MPDataDirectory(NSString *relativePath);
NSString *MPPathToDataFile(NSString *name, NSString *dirPath);

NSArray *MPListEntriesForDirectory(
    NSString *dirName, NSString *(^processor)(NSString *absolutePath)
);

// Block factory for MPListEntriesForDirectory
NSString *(^MPFileNameHasSuffixProcessor(NSString *suffix))(NSString *path);

BOOL MPCharacterIsWhitespace(unichar character);
BOOL MPCharacterIsNewline(unichar character);
BOOL MPStringIsNewline(NSString *str);

NSString *MPStylePathForName(NSString *name);
NSString *MPThemePathForName(NSString *name);
NSURL *MPHighlightingThemeURLForName(NSString *name);
NSString *MPReadFileOfPath(NSString *path);

NSDictionary *MPGetDataMap(NSString *name);

id MPGetObjectFromJavaScript(NSString *code, NSString *variableName);
