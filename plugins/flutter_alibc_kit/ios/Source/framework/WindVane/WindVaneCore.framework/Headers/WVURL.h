/*
 * WVURL.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

#pragma mark - WVURLQueryItem

/**
 * URL 的查询项。
 * 若查询项的 '=' 前不包含内容，那么相应 WVURLQueryItem 的 name 属性为空字符串。
 * 若查询项的 '=' 后不包含内容，那么相应 WVURLQueryItem 的 value 属性为空字符串。
 * 若查询项不包含 '='，那么相应 WVURLQueryItem 的 value 属性为 nil。
 * 若查询项为空（即查询字符串以 '&' 开头、以 '&' 结尾或者包含 '&&' 时），那么相应 WVURLQueryItem 的 name 属性为空字符串，value 属性为 nil。
 */
@interface WVURLQueryItem : NSObject <NSCopying>

/**
 * URL 查询的名称。
 */
@property (nonatomic, copy, readonly, nonnull) NSString * name;

/**
 * URL 查询的值。
 */
@property (nonatomic, copy, readonly, nullable) NSString * value;

/**
 * 返回空的查询项（name 为空字符串，value 为 nil）。
 */
+ (WVURLQueryItem * _Nonnull)empty;

/**
 * 使用指定的查询项（name=value）初始化。
 *
 * @param query URL 的查询项。
 *
 * @return URL 查询项。
 */
+ (instancetype _Nonnull)queryItemWithQuery:(NSString * _Nonnull)query;
/**
 * 使用指定的查询名称和值初始化。
 *
 * @param name  URL 的查询名称。
 * @param value URL 的查询值。
 *
 * @return URL 查询项。
 */
+ (instancetype _Nonnull)queryItemWithName:(NSString * _Nonnull)name value:(NSString * _Nullable)value;

/**
 * 使用指定的查询名称和值初始化。
 *
 * @param name  URL 的查询名称。
 * @param value URL 的查询值。
 */
- (instancetype _Nonnull)initWithName:(NSString * _Nonnull)name value:(NSString * _Nullable)value NS_DESIGNATED_INITIALIZER;

/**
 * 返回当前查询是否为空查询项（name 为空字符串，value 为 nil）。
 *
 * @return 如果是空查询项，则为 YES；否则为 NO。
 */
- (BOOL)isEmpty;

/**
 * 返回当前查询项是否与指定查询项内容相同。
 *
 * @param queryItem 要检查的查询项。
 *
 * @return 如果内容相同，则为 YES；否则为 NO。
 */
- (BOOL)isEqualToQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 返回当前查询项的字符串格式。
 *
 * @return 当前查询项的字符串格式。
 */
- (NSString * _Nonnull)queryString;

@end

#pragma mark - WVURL

// 部分常用的固定 Scheme，参考 http://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml。
typedef NS_ENUM(NSInteger, WVURLScheme) {
	// 此枚举中未列出的 Scheme。
	WVURLSchemeNotListed = -1,
	// 无 Scheme。
	WVURLSchemeNone = 0,
	// about [RFC6694]
	WVURLSchemeAbout,
	// data [RFC2397]
	WVURLSchemeData,
	// Host-specific file names [RFC1738]
	WVURLSchemeFile,
	// File Transfer Protocol [RFC1738]
	WVURLSchemeFtp,
	// Hypertext Transfer Protocol [RFC7230, Section 2.7.1]
	WVURLSchemeHttp,
	// Hypertext Transfer Protocol Secure [RFC7230, Section 2.7.2]
	WVURLSchemeHttps,
	// Instant Messaging [RFC3860]
	WVURLSchemeIM,
	// Electronic mail address [RFC6068]
	WVURLSchemeMailto,
	// Short Message Service [RFC5724]
	WVURLSchemeSms,
	// telephone [RFC3966]
	WVURLSchemeTel,
};

// WVURL 的查询选项。
typedef NS_OPTIONS(NSInteger, WVURLQueryOptions) {
	// [追加&替换]查询会追加到起始位置，而不是结束位置。
	WVURLQueryPrepend = 1 << 0,
	// [追加]如果要追加的查询键已存在，则不再追加。如果与 WVURLQueryCompareItem 一起使用，那么只会生效 WVURLQueryCompareItem。
	WVURLQueryCompareKey = 1 << 1,
	// [追加]如果要追加的查询键和值已存在，则不再追加。
	WVURLQueryCompareItem = 1 << 2,
	// [替换]如果要替换的查询不存在，则自动追加。
	WVURLQueryAutoAppend = 1 << 3,
	// [替换]替换查询的第一次出现，移除其它出现。
	WVURLQueryReplaceAll = 1 << 4,
};

// about:blank 的 URL。
FOUNDATION_EXPORT NSString * _Nonnull const WVURLStringBlank;

/**
 * 包含 URL 的操作，格式参照 RFC 3986，提供对 Combo 的支持，但不会做任何编码、解码操作。
 * url = [<scheme> :] [// <authority>] / <path> [?? <comboPath>] [? <query>] [# <fragment>]
 * 
 * 对相同 URL 的多次操作，请使用相应实例方法。
 */
@interface WVURL : NSObject

/**
 * 当前 URL 字符串。
 */
@property (nonatomic, copy, readonly, nonnull) NSString * urlString;

/**
 * 使用指定的字符串得到 WVURL 的新实例。
 */
+ (instancetype _Nullable)URLWithString:(NSString * _Nullable)urlString;

/**
 * 使用指定的 NSURL 得到 WVURL 的新实例。
 */
+ (instancetype _Nullable)URLWithNSURL:(NSURL * _Nullable)url;

/**
 * 使用指定的 URL 字符串初始化。
 *
 * @param urlString URL 字符串，不能为 nil。
 */
- (instancetype _Nullable)initWithString:(NSString * _Nonnull)urlString;

/**
 * 检查指定的 URL 是否是空地址，支持 NSURL * 和 NSString *。
 */
+ (BOOL)isBlank:(id _Nullable)url;

#pragma mark - Scheme

/**
 * URL 的 scheme。
 *
 * @discussion scheme 总是由小写字母组成，且不会包含最后的 ':'；如果不包含 scheme，则为 nil，scheme 不会为空字符串。
 */
@property (nonatomic, copy, nullable) NSString * scheme;

/**
 * 已定义的 scheme 枚举。
 */
@property (nonatomic, assign) WVURLScheme schemeDefine;

/**
 * 返回当前 url scheme 是否是 http 或 https。
 */
- (BOOL)isHttpOrHttps;

/**
 * 返回当前 url scheme 是否可能是应用 scheme（可以跳转到外部应用）。
 */
- (BOOL)isAppScheme;

/**
 * 返回指定 url scheme 是否是 http 或 https。
 */
+ (BOOL)isHttpOrHttps:(NSURL * _Nullable)url;

/**
 * 返回指定 url scheme 是否可能是应用 scheme（可以跳转到外部应用）。
 */
+ (BOOL)isAppScheme:(NSURL * _Nullable)url;

/**
 * 返回指定 URL 的 scheme。
 *
 * @param url 要获取 scheme 的 URL。
 *
 * @return 指定 URL 的 scheme。
 */
+ (NSString * _Nullable)getScheme:(NSString * _Nullable)url;

/**
 * 返回指定 URL 的已定义的 scheme 枚举。
 *
 * @param url 要获取已定义的 scheme 枚举的 URL。
 *
 * @return 指定 URL 的已定义的 scheme 枚举。
 */
+ (WVURLScheme)getSchemeDefine:(NSString * _Nullable)url;

/**
 * 移除 URL 的 scheme。
 *
 * @param url 要移除 scheme 的 URL。
 *
 * @return 移除 scheme 后的 URL。
 */
+ (NSString * _Nullable)urlWithoutScheme:(NSString * _Nullable)url;

#pragma mark - Authority

/**
 * URL 的 Authority。
 *
 * @discussion authority 不会包含起始的 '//'；如果不包含 authority，如 'http://'，则为 nil；如果包含空 authority，如 'http:///path'，则为空字符串。
 */
@property (nonatomic, copy, nullable) NSString * authorityString;

/**
 * URL Authority 中的用户信息部分。
 *
 * @discussion userInfo 不会包含与 host 分割的 '@'；如果 Authority 不包含 '@'，则为 nil；如果 '@' 前没有其它字符，则为空字符串。
 */
@property (nonatomic, copy, nullable) NSString * userInfo;

/**
 * URL Authority 中的 Host 部分。
 *
 * @discussion 如果 Authority 为 nil，那么 host 也为 nil；否则 host 不会为 nil。
 */
@property (nonatomic, copy, nullable) NSString * host;

/**
 * URL Authority 中的端口部分。
 *
 * @discussion port 不会包含与 host 分割的 ':'；如果 Authority 不包含 ':'，则为 nil；如果 ':' 后没有其它字符，则为空字符串。
 * 这里不会对 port 的有效性（是否全部由数字组成）做校验，需要使用方自行处理无效的 port。
 */
@property (nonatomic, copy, nullable) NSString * port;

/**
 * URL Authority 中的端口部分是否有效。
 */
@property (nonatomic, assign, readonly, getter=isPortValid) BOOL portValid;

/**
 * 返回指定的端口是否有效。
 */
+ (BOOL)isValidPort:(NSString * _Nullable)port;

#pragma mark - Path

/**
 * URL 的路径字符串。
 *
 * @discussion 如果不包含 path，则为 nil。
 */
@property (nonatomic, copy, nullable) NSString * pathString;

/**
 * 返回当前 URL 的 MIME Type。
 */
- (NSString * _Nonnull)getMimeType;

/**
 * 返回指定 URL 是否是 HTML URL。
 */
+ (BOOL)isHTML:(NSString * _Nullable)url;

/**
 * 返回指定 URL 是否是 JS URL。
 */
+ (BOOL)isJS:(NSString * _Nullable)url;

/**
 * 返回指定 path 的 MIME 类型。
 */
+ (NSString * _Nullable)getMimeTypeWithPath:(NSString * _Nullable)path;

/**
 * 根据文件内容猜测 MIME 类型。
 */
+ (NSString * _Nonnull)getMimiTypeFromData:(NSData * _Nullable)data;

/**
 * 将指定路径拼装到当前路径的末尾，并返回新路径。
 * 与 [NSString stringByAppendingPathComponent:] 不同的是，NSString 提供的方法会将 http:// 强制改为 http:/，而本方法不会。
 */
+ (NSString * _Nullable)stringByAppendingPathComponent:(NSString * _Nullable)basePath withPathComponent:(NSString * _Nullable)pathComponent;

#pragma mark - Combo Path

/**
 * Combo 路径字符串。
 *
 * @discussion 如果不包含 Combo 路径，则为 nil。
 */
@property (nonatomic, copy, nullable) NSString * comboPathString;

/**
 * Combo 路径数组，数组的每一项对应一个 Combo 路径。
 *
 * @discussion 如果不包含 Combo 路径，则为 nil，comboPathArray 不会为空数组。
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> * comboPathArray;

/**
 * 返回指定 combo 路径对应的 URL 字符串。
 */
- (NSString * _Nullable)getComboURLString:(NSString * _Nullable)comboPath;

/**
 * 判断指定的 URL 是否是 Combo URL。
 */
+ (BOOL)isComboUrl:(NSString * _Nullable)url;

#pragma mark - Query

/**
 * URL 的查询字符串。
 *
 * @discussion 如果不包含查询，如 'http://host/path'，则为 nil；如果包含空查询，如 'http://host/path?'，则为空字符串。
 */
@property (nonatomic, copy, nullable) NSString * queryString;

/**
 * URL 的查询数组，数组的每一项都是 WVURLQueryItem 类型。
 *
 * @discussion 如果不包含查询，如 'http://host/path'，则为 nil；如果包含空查询，如 'http://host/path?'，则为包含一个 [WVURLQueryItem empty] 对象的数组。
 *             这里永远不会返回空数组，设置时会被当做 nil 看待。
 */
@property (nonatomic, copy, nullable) NSArray<WVURLQueryItem *> * queryItems;

/**
 * 返回指定 URL 的查询字符串。
 */
+ (NSString * _Nullable)urlQuery:(NSString * _Nullable)url;

/**
 * 将查询项数组转换为相应的字典，
 * 同名的查询会取最后一个；值为 nil 的查询，会使用空字符串表示。
 *
 * @param queryItems 查询项数组。
 *
 * @return 对应的字典。
 */
+ (NSMutableDictionary<NSString *, NSString *> * _Nullable)queryItemsToDictionary:(NSArray<WVURLQueryItem *> * _Nullable)queryItems;

/**
 * 将查询项数组转换为相应的字符串，
 *
 * @param queryItems 查询项数组。
 *
 * @return 对应的字符串。
 */
+ (NSString * _Nullable)queryItemsToString:(NSArray<WVURLQueryItem *> * _Nullable)queryItems;

/**
 * 分析指定的查询字符串。
 *
 * @param queryString 要分析的查询，为 name1=value1&name2=value2 的格式。
 */
+ (NSMutableArray<WVURLQueryItem *> * _Nullable)parseQueryString:(NSString * _Nullable)queryString;

/**
 * 分析指定的查询字符串为字典。
 * 同名的查询会取最后一个；值为 nil 的查询，会使用空字符串表示。
 *
 * @param queryString 要分析的查询，为 name1=value1&name2=value2 的格式。
 */
+ (NSMutableDictionary<NSString *, NSString *> * _Nullable)parseQueryStringAsDictionary:(NSString * _Nullable)queryString;

#pragma mark Contains Query

/**
 * 返回当前 URL 是否包含指定名称的查询。
 *
 * @param queryName 要检查的查询名称。
 *
 * @return 如果包含指定名称和值的查询，则为 YES；否则为 NO。
 */
- (BOOL)containsQuery:(NSString * _Nullable)queryName;

/**
 * 返回当前 URL 是否包含指定查询。
 *
 * @param queryItem 要判断的查询。
 *
 * @return 如果包含指定查询，则为 YES；否则为 NO。
 */
- (BOOL)containsQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 返回当前 URL 是否包含指定名称和值的查询。
 *
 * @param queryName 要检查的查询名称。
 * @param value     要检查的查询值。
 *
 * @return 如果包含指定名称和值的查询，则为 YES；否则为 NO。
 */
- (BOOL)containsQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 返回当前 URL 是否包含指定的查询。
 *
 * @param queries 要检查的查询，为 name=value 的格式，只能支持一个查询。
 *
 * @return 如果包含指定的查询，则为 YES；否则为 NO。
 */
- (BOOL)containsQueries:(NSString * _Nullable)queries;

/**
 * 返回指定 URL 是否包含指定名称的查询。
 *
 * @param url       要检查的 URL。
 * @param queryName 要检查的查询名称，不能为 nil。
 *
 * @return 如果包含指定名称的查询，则为 YES；否则为 NO。
 */
+ (BOOL)isUrl:(NSString * _Nullable)url containsQuery:(NSString * _Nullable)queryName;

/**
 * 返回当前 URL 是否包含指定查询。
 *
 * @param queryItem 要判断的查询。
 *
 * @return 如果包含指定查询，则为 YES；否则为 NO。
 */
+ (BOOL)isUrl:(NSString * _Nullable)url containsQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 返回指定 URL 是否包含指定名称和值的查询。
 *
 * @param url       要检查的 URL。
 * @param queryName 要检查的查询名称。
 * @param value     要检查的查询值。
 *
 * @return 如果包含指定名称和值的查询，则为 YES；否则为 NO。
 */
+ (BOOL)isUrl:(NSString * _Nullable)url containsQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 返回当前 URL 是否包含指定的查询。
 *
 * @param queries 要检查的查询，为 name=value 的格式，只能支持一个查询。
 *
 * @return 如果包含指定的查询，则为 YES；否则为 NO。
 */
+ (BOOL)isUrl:(NSString * _Nullable)url containsQueries:(NSString * _Nullable)queries;

#pragma mark Get Query

/**
 * 返回当前 URL 指定查询第一次出现的值。
 *
 * @param queryName 查询的名称。
 *
 * @return 查询第一次出现的值。如果查询不存在，则返回 nil；如果查询存在但值为 nil，则返回空字符串。
 */
- (NSString * _Nullable)getQueryValue:(NSString * _Nullable)queryName;

/**
 * 返回当前 URL 指定查询第一次出现的值。
 *
 * @param queryName 查询的名称。
 * @param value     返回查询第一次出现的值。
 *
 * @return 如果找到了指定的查询，则为 YES；否则为 NO。
 */
- (BOOL)getQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable * _Nonnull)value;

/**
 * 返回指定 URL 指定查询第一次出现的值。
 *
 * @param queryName 查询的名称。
 *
 * @return 查询第一次出现的值。如果查询不存在，则返回 nil；如果查询存在但值为 nil，则返回空字符串。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url getQueryValue:(NSString * _Nullable)queryName;

/**
 * 返回指定 URL 指定查询第一次出现的值。
 *
 * @param queryName 查询的名称。
 * @param value     返回查询第一次出现的值。
 *
 * @return 如果找到了指定的查询，则为 YES；否则为 NO。
 */
+ (BOOL)url:(NSString * _Nullable)url getQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable * _Nonnull)value;

#pragma mark Append Query

/**
 * 向当前 URL 的查询追加指定的查询。
 *
 * @param queryItem 要追加的查询。
 */
- (void)appendQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 向当前 URL 的查询追加指定名称和值的查询。
 *
 * @param queryItem 要追加的查询。
 * @param options   追加的选项，可用的选项有 WVURLQueryPrepend、WVURLQueryCompareKey 和 WVURLQueryCompareItem。
 */
- (void)appendQueryItem:(WVURLQueryItem * _Nullable)queryItem options:(WVURLQueryOptions)options;

/**
 * 向当前 URL 的查询追加指定名称和值的查询。
 *
 * @param queryName 查询的名称。
 * @param value     查询的值。
 */
- (void)appendQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 向当前 URL 的查询追加指定名称和值的查询。
 *
 * @param queryName 查询的名称。
 * @param value     查询的值。
 * @param options   追加的选项，可用的选项有 WVURLQueryPrepend、WVURLQueryCompareKey 和 WVURLQueryCompareItem。
 */
- (void)appendQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value options:(WVURLQueryOptions)options;

/**
 * 向当前 URL 的查询追加指定的查询，支持一次性增加单个或多个查询。
 *
 * @param queries 要追加的查询，为 name1=value1&name2=value2 的格式。
 */
- (void)appendQueries:(NSString * _Nullable)queries;

/**
 * 向当前 URL 的查询追加指定的查询，支持一次性增加单个或多个查询。
 *
 * @param queries 要追加的查询，为 name1=value1&name2=value2 的格式。
 * @param options 追加的选项，可用的选项有 WVURLQueryPrepend、WVURLQueryCompareKey 和 WVURLQueryCompareItem。
 */
- (void)appendQueries:(NSString * _Nullable)queries options:(WVURLQueryOptions)options;

/**
 * 向指定 URL 的查询追加指定的查询。
 *
 * @param url       要追加的 URL。
 * @param queryItem 要追加的查询。
 *
 * @return 已追加查询的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url appendQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 向指定 URL 的查询追加指定的查询。
 *
 * @param url       要追加的 URL。
 * @param queryItem 要追加的查询。
 * @param options   追加的选项，可用的选项有 WVURLQueryPrepend、WVURLQueryCompareKey 和 WVURLQueryCompareItem。
 *
 * @return 已追加查询的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url appendQueryItem:(WVURLQueryItem * _Nullable)queryItem options:(WVURLQueryOptions)options;

/**
 * 向指定 URL 的查询追加指定名称和值的查询。
 *
 * @param url       要追加的 URL。
 * @param queryName 要追加的查询名称。
 * @param value     要追加的查询值。
 *
 * @return 已追加查询的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url appendQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 向指定 URL 的查询追加指定名称和值的查询。
 *
 * @param url       要追加的 URL。
 * @param queryName 要追加的查询名称。
 * @param value     要追加的查询值。
 * @param options   追加的选项，可用的选项有 WVURLQueryPrepend、WVURLQueryCompareKey 和 WVURLQueryCompareItem。
 *
 * @return 已追加查询的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url appendQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value options:(WVURLQueryOptions)options;

/**
 * 向指定 URL 的查询追加指定的查询，支持一次性增加单个或多个查询。
 *
 * @param url     要追加的 URL。
 * @param queries 要追加的查询，为 name1=value1&name2=value2 的格式。
 *
 * @return 已追加查询的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url appendQueries:(NSString * _Nullable)queries;

/**
 * 向指定 URL 的查询追加指定的查询，支持一次性增加单个或多个查询。
 *
 * @param url     要追加的 URL。
 * @param queries 要追加的查询，为 name1=value1&name2=value2 的格式。
 * @param options 追加的选项，可用的选项有 WVURLQueryPrepend、WVURLQueryCompareKey 和 WVURLQueryCompareItem。
 *
 * @return 已追加查询的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url appendQueries:(NSString * _Nullable)queries options:(WVURLQueryOptions)options;
;

#pragma mark Remove Query

/**
 * 移除所有具有指定名称的查询。
 *
 * @param queryName 查询的名称。
 */
- (void)removeQuery:(NSString * _Nullable)queryName;

/**
 * 移除所有指定名称的空（值为 nil 或空字符串）查询。
 *
 * @param queryName 查询的名称。
 */
- (void)removeEmptyQuery:(NSString * _Nullable)queryName;

/**
 * 移除所有指定的查询。
 *
 * @param queryItem 要移除的查询。
 */
- (void)removeQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 移除所有指定名称和值的查询。
 *
 * @param queryName 要移除的查询的名称。
 * @param value     要移除的查询的值。
 */
- (void)removeQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 移除所有指定名称和值的查询。
 *
 * @param queries 要移除的查询，为 name=value 的格式，只能支持一个查询。
 */
- (void)removeQueries:(NSString * _Nullable)queries;

/**
 * 从指定的 URL 中移除所有具有指定名称的查询。
 *
 * @param url       要检查的 URL。
 * @param queryName 要移除的查询的名称。
 *
 * @return 移除指定查询后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url removeQuery:(NSString * _Nullable)queryName;

/**
 * 从指定的 URL 中移除所有指定名称的空（值为 nil 或空字符串）查询。
 *
 * @param url       要检查的 URL。
 * @param queryName 要移除的查询的名称。
 *
 * @return 移除指定查询后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url removeEmptyQuery:(NSString * _Nullable)queryName;

/**
 * 从指定的 URL 中移除所有指定查询。
 *
 * @param url       要检查的 URL。
 * @param queryItem 要移除的查询。
 *
 * @return 移除指定查询后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url removeQueryItem:(WVURLQueryItem * _Nullable)queryItem;

/**
 * 从指定的 URL 中移除所有指定名称和值的查询。
 *
 * @param url       要检查的 URL。
 * @param queryName 要移除的查询的名称。
 * @param value     要移除的查询的值。
 *
 * @return 移除指定查询后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url removeQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 从指定的 URL 中移除所有指定的查询。
 *
 * @param url     要检查的 URL。
 * @param queries 要移除的查询，为 name=value 的格式，只能支持一个查询。
 *
 * @return 移除指定查询后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url removeQueries:(NSString * _Nullable)queries;

#pragma mark Replace Query

/**
 * 将指定的查询替换为指定的值。
 *
 * @param queryName 查询的名称。
 * @param value     查询的新值。
 */
- (void)replaceQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 将指定的查询替换为指定的值。
 *
 * @param queryName 查询的名称。
 * @param value     查询的新值。
 * @param options   查询的替换选项，可用的选项有 WVURLQueryPrepend、WVURLQueryAutoAppend 和 WVURLQueryReplaceAll。
 */
- (void)replaceQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value options:(WVURLQueryOptions)options;

/**
 * 将指定 URL 的的查询替换为指定的值。
 *
 * @param queryName 查询的名称。
 * @param value     查询的新值。
 *
 * @return 替换后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url replaceQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value;

/**
 * 将指定 URL 的的查询替换为指定的值。
 *
 * @param queryName 查询的名称。
 * @param value     查询的新值。
 * @param options   查询的替换选项，可用的选项有 WVURLQueryPrepend、WVURLQueryAutoAppend 和 WVURLQueryReplaceAll。
 *
 * @return 替换后的 URL。
 */
+ (NSString * _Nullable)url:(NSString * _Nullable)url replaceQuery:(NSString * _Nullable)queryName withValue:(NSString * _Nullable)value options:(WVURLQueryOptions)options;

/**
 * 清空 Query 和 Fragment。
 */
- (void)clearQueryAndFragment;

/**
 * 移除 URL 中的查询参数和 Fragment。
 */
+ (NSString * _Nullable)urlWithoutQueryAndFragment:(NSString * _Nullable)url;

#pragma mark - Fragment

/**
 * URL 的 Fragment。
 *
 * @discussion 如果不包含 Fragment，如 'http://host/path'，则为 nil；如果包含空 Fragment，如 'http://host/path#'，则为空字符串。
 */
@property (nonatomic, copy, nullable) NSString * fragment;

/**
 * 移除 URL 中的 Fragment。
 */
+ (NSString * _Nullable)urlWithoutFragment:(NSString * _Nullable)url;

/**
 * 比较两个 URL 是否相同（忽略 fragment）。
 *
 * @param url1 要比较的第一个 URL。
 * @param url2 要比较的第二个 URL。
 */
+ (BOOL)compareWithoutFragment:(NSString * _Nullable)url1 withURL:(NSString * _Nullable)url2;

@end

#pragma mark - NSURL (WVURL)

/**
 * 为 NSURL 提供的扩展方法。
 */
@interface NSURL (WVURL)

/**
 * 已定义的 scheme 枚举。
 */
@property (nonatomic, assign, readonly) WVURLScheme wvSchemeDefine;

@end
