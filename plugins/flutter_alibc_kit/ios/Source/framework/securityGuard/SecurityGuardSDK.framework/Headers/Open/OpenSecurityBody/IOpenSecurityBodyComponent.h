//
// OpenSecurityGuardSDK version 2.1.0
//

#import <Foundation/Foundation.h>

@protocol IOpenSecurityBodyComponent <NSObject>

/**
 *  获取风控参数
 *  @return 用户昵称，获取失败返回nil
 */
- (NSString*) getSecurityBodyDataEx: (NSString*) timeStamp
                             appKey: (NSString*) appKey
                           authCode: (NSString*) authCode
                        extendParam: (NSDictionary*) extendParam
                               flag: (int) flag
                                env: (int) env
                              error: (NSError* __autoreleasing*) error;



/// 进入某个风险场景之后，调用该接口，传递具体的场景以及检测数据
/// @param scene 具体的风险场景
/// @param riskParam 风险场景传递的参数
/// @param error 错误码
- (BOOL) enterRiskScene: (int) scene
              riskParam: (NSDictionary *) riskParam
                  error: (NSError* __autoreleasing*) error;


/// 离开某个风险场景时，需要调用该接口
/// @param scene 具体的风险场景
/// @param error 错误码
- (BOOL) leaveRiskScene: (int) scene
                  error: (NSError* __autoreleasing*) error;


/// 新的获取WUA的接口
/// @param authCode 图片后缀，传null使用默认图片yw_1222.jpg
/// @param extendParam 业务传入的自定义参数，保存在jaqParam
/// @param flag 决定生成的 wua 的格式，本参数必选，见文档
/// @param env wua 的环境参数，本参数必选，见文档
/// @param error 错误码
- (NSString*) getSecurityBodyDataEx: (NSString*) authCode
                        extendParam: (NSDictionary*) extendParam
                               flag: (int) flag
                                env: (int) env
                              error: (NSError* __autoreleasing*) error;

@end
