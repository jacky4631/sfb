

@class TBSDKConnection;

@protocol TBSDKConnectionDelegate <NSObject>

@optional

- (void)requestStarted:(TBSDKConnection *)connection;
- (void)request:(TBSDKConnection *)connection didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)request:(TBSDKConnection *)connection willRedirectToURL:(NSURL *)newURL;
- (void)requestFinished:(TBSDKConnection *)connection;
- (void)requestNetworkDataSet:(NSDictionary *) networkDataSet withFinishedTime:(CFAbsoluteTime) finishedTime;
- (void)requestFailed:(TBSDKConnection *)connection;
- (void)requestRedirected:(TBSDKConnection *)connection;
- (void)request:(TBSDKConnection *)connection didReceiveData:(NSData *)data;
- (void)authenticationNeededForRequest:(TBSDKConnection *)connection;
- (void)proxyAuthenticationNeededForRequest:(TBSDKConnection *)connection;

@end
