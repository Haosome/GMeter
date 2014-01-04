//
//  MessagingToolModel.m
//  GBluetooth
//
//  Created by Hao Guo on 2012-10-20.
//
//

#import "MessagingToolModel.h"
@interface MessagingToolModel ()

@end

@implementation MessagingToolModel

+(NSString* )getFileContent: (NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,fileName];
    return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+(void)writeToFile:(NSString *)fileName contentToWrite:(NSString *)content{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:@"data"];
    filePath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
    [content  writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

+(NSArray *)requireList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:nil];
}

+(void) deleteAllFiles{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
   documentDirectory = [documentDirectory stringByAppendingPathComponent:@"Data"];
    [[NSFileManager defaultManager] removeItemAtPath:documentDirectory error:nil];
}

+(NSString *)getDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

+(void)appendToFile:(NSString *)fileName contentToAppend:(NSString *)content{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"data"];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    unsigned long long i =[fileHandle seekToEndOfFile];
    //NSLog(@"%llu",i);
    [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

@end
