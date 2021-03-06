//
//  GModel.m
//  GTOOL
//
//  Created by tg on 2020/12/23.
//

#import "GModel.h"
#import <objc/runtime.h>
#import "GModelManger.h"
#import "GHeader.h"
@interface GModel()

@end
@implementation GModel
//GHELPER_SHARED(GModel)
//kSingletonImplementation_M(GModel)
-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

//-(GModel * _Nonnull (^)(ArchiveType))archiveWithType{
//    __weak typeof(self) weakSelf = self;
////    GModel* (^result)(ArchiveType type) = ^(ArchiveType type){
////        return weakSelf;
////
////      };
//    return ^(ArchiveType type){
//        return weakSelf;
//    };
//}


- (NSMutableArray *)getProperties
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    Class targetClass = [self class];
    while (targetClass != [GModel class] && targetClass != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
        for (i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            const char *char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [props addObject:propertyName];
        }
        free(properties);
        targetClass = [targetClass superclass];
    }
    return props;
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [[self getProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aCoder encodeObject:[self valueForKey:obj] forKey:obj];
    }];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        [[self getProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self setValue:[aDecoder decodeObjectForKey:obj] forKey:obj];
        }];
    }
    
    return self;
}



- (NSString *)description {
    
#if defined(DEBUG) && DEBUG
    unsigned int count;
    const char *clasName = object_getClassName(self);
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%s: %p>:[",clasName, self];
    Class clas = NSClassFromString([NSString stringWithCString:clasName encoding:NSUTF8StringEncoding]);
    Ivar *ivars = class_copyIvarList(clas, &count);
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            
            //????????????
            NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            
            
            if ([key isEqualToString:@"_array_Temp"]) {
                break ;
            }
            id value = [self valueForKey:key];
            //??????BOOL ???????????????YES ??? NO????????????B???????????????????????????????????????
            if ([type isEqualToString:@"B"]) {
                value = (value == 0 ? @"NO" : @"YES");
            }
            //            [string appendFormat:@"\t%@ = %@\n",[self delLine:key], value];
            [string appendFormat:@"  %@=%@  ",key, value];
            
        }
    }
    [string appendFormat:@"]"];

    return string;
    #endif
    return @"";
}




-(void)g_convertForm:(GModel*)model{
    NSMutableArray* array =   [self getProperties];
    GModel* modelSuper =  model;
    NSMutableArray* arraySuper =   [modelSuper getProperties];
    [array enumerateObjectsUsingBlock:^(NSString* properNames, NSUInteger idx, BOOL * _Nonnull stop) {
        [arraySuper enumerateObjectsUsingBlock:^(NSString* properNameSuper, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([properNames isEqualToString:properNameSuper]) {
                if (kISEmpty([modelSuper valueForKey:properNames])) {
                    [self setValue:[modelSuper valueForKey:properNames]  forKey:properNames];
                }
                [arraySuper removeObject:properNameSuper];
            }
        }];
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"-------------undefined  %@---------------",key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"-------------undefined  %@ : value: %@---------------",key,@"???");
    return @"";
}



#pragma mark - ?????????????????????????????????
/// ???????????? ???????????????????????????
+(NSString*)g_setDBTableNameMarker{
    return @"DBUserInfoModel_Name";

}
///????????????????????????
+(Class)g_setDBClassModelMarker{
    return  [self class];

}
/////??????????????????????????????????????????nil??????????????????
//+(NSArray<NSString*>*)g_setDBExcludedProperties{
//    return @[@"userID"];
//
//}
///???????????????????????????????????????????????????GModel????????????????????????????????????????????????????????????
//+(NSString*)g_setDBQueryMarker{
//    return NSStringFromClass([self class]);
//}

#pragma mark- ??????????????????????????????
///??????
-(void)g_dbInsert{
    [GModelManger insertWithModel:(GModel*)self];

}
-(void)g_dbInsertWithWithModels:(NSArray<GModel*>*)models{
    [GModelManger insertWithModels:models];
}
///??????
-(void)g_dbDel{
    [GModelManger delWithModel:(GModel*)self withORID:nil];
}
-(void)g_dbDelwithORQueryID:(NSString*)iD{
    [GModelManger delWithModel:(GModel*)self withORID:iD];
}

///??????
-(void)g_dbUpdate{
    [GModelManger updateWithModel:(GModel*)self];
}
///??????
+(NSArray<GModel*>*)g_dbQueryAll{
    return  [GModelManger queryFromTableWithMarkClass:[self class]];
}
-(NSArray<GModel*>*)g_dbQueryWithIDArray:(NSArray<NSString*>*)idArray{
    return  [GModelManger queryFromTableWithIDArray:idArray withMarkClass:[self class]];
}
///????????????????????????
-(BOOL)g_dbIsContain{
    return  [GModelManger isContainsWith:(GModel*)self];
}
///????????????????????????
+(void)g_dbTableChangeBlock:(void (^)(void))block{
    [GModelManger dbTableChangeBLock:block];
}


#pragma mark - ??????????????????????????????
-(NSString*)g_setArchiveMarker{
    return NSStringFromClass([self class]);
}

#pragma mark- ???????????????????????????
///??????archive??????
+(__kindof GModel*)g_archiveGet{
    return  [GModelManger archiveGetWithClass:[self class]];
}

-(void)g_archiveUpdate{
    return  [GModelManger archiveUpdateWithClass:[self class] with:self];
}

////??????ArchiveModel
+(void)g_archiveDel{
    [GModelManger archiveDelWithClass:[self class]];
   
}
////??????ArchiveModel?????????????????????????????????
+(__kindof GModel *)g_archiveWithBlock:(void (^)(__kindof GModel* modelSub))block{
    return  [GModelManger archiveWithClass:[self class] wtihBlock:block];
}
@end
