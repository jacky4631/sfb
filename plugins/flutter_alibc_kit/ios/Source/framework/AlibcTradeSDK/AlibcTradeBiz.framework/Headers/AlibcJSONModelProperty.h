/*
 * AlibcJSONModelProperty.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
/*
 相关知识请参见Runtime文档
 Type Encodings https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 Property Type String https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
 */
typedef NS_ENUM(NSInteger, AlibcJSONModelPropertyValueType) {
    AlibcClassPropertyValueTypeNone = 0,
    AlibcClassPropertyTypeChar,
    AlibcClassPropertyTypeInt,
    AlibcClassPropertyTypeShort,
    AlibcClassPropertyTypeLong,
    AlibcClassPropertyTypeLongLong,
    AlibcClassPropertyTypeUnsignedChar,
    AlibcClassPropertyTypeUnsignedInt,
    AlibcClassPropertyTypeUnsignedShort,
    AlibcClassPropertyTypeUnsignedLong,
    AlibcClassPropertyTypeUnsignedLongLong,
    AlibcClassPropertyTypeFloat,
    AlibcClassPropertyTypeDouble,
    AlibcClassPropertyTypeBool,
    AlibcClassPropertyTypeVoid,
    AlibcClassPropertyTypeCharString,
    AlibcClassPropertyTypeObject,
    AlibcClassPropertyTypeClassObject,
    AlibcClassPropertyTypeSelector,
    AlibcClassPropertyTypeArray,
    AlibcClassPropertyTypeStruct,
    AlibcClassPropertyTypeUnion,
    AlibcClassPropertyTypeBitField,
    AlibcClassPropertyTypePointer,
    AlibcClassPropertyTypeUnknow
};

@interface AlibcJSONModelProperty : NSObject{
    @public
    NSString *_name;
    AlibcJSONModelPropertyValueType _valueType;
    NSString *_typeName;
    Class _objectClass;
    NSArray *_objectProtocols;
    Class _containerElementClass;
    BOOL _isReadonly;
}

+ (instancetype)propertyWithName:(NSString *)name typeString:(NSString *)typeString;

@end
