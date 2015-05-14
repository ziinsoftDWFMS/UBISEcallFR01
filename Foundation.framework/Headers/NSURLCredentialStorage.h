/*	
    NSURLCredentialStorage.h
    Copyright (c) 2003-2014, Apple Inc. All rights reserved.    
    
    Public header file.
*/

#import <Foundation/NSObject.h>

@class NSDictionary;
@class NSString;
@class NSURLCredential;
@class NSURLProtectionSpace;
@class NSURLSessionTask;

@class NSURLCredentialStorageInternal;

/*!
    @class NSURLCredentialStorage
    @discussion NSURLCredentialStorage implements a singleton object (shared instance) which manages the shared credentials cache. Note: Whereas in Mac OS X any application can access any credential with a persistence of NSURLCredentialPersistencePermanent provided the user gives permission, in iPhone OS an application can access only its own credentials.
*/

@interface NSURLCredentialStorage : NSObject
{
    @private
    NSURLCredentialStorageInternal *_internal;
}

/*!
    @method sharedCredentialStorage
    @abstract Get the shared singleton authentication storage
    @result the shared authentication storage
*/
+ (NSURLCredentialStorage *)sharedCredentialStorage;

/*!
    @method credentialsForProtectionSpace:
    @abstract Get a dictionary mapping usernames to credentials for the specified protection space.
    @param protectionSpace An NSURLProtectionSpace indicating the protection space for which to get credentials
    @result A dictionary where the keys are usernames and the values are the corresponding NSURLCredentials.
*/
- (NSDictionary *)credentialsForProtectionSpace:(NSURLProtectionSpace *)space;

/*!
    @method allCredentials
    @abstract Get a dictionary mapping NSURLProtectionSpaces to dictionaries which map usernames to NSURLCredentials
    @result an NSDictionary where the keys are NSURLProtectionSpaces
    and the values are dictionaries, in which the keys are usernames
    and the values are NSURLCredentials
*/
@property (readonly, copy) NSDictionary *allCredentials;

/*!
    @method setCredential:forProtectionSpace:
    @abstract Add a new credential to the set for the specified protection space or replace an existing one.
    @param credential The credential to set.
    @param space The protection space for which to add it. 
    @discussion Multiple credentials may be set for a given protection space, but each must have
    a distinct user. If a credential with the same user is already set for the protection space,
    the new one will replace it.
*/
- (void)setCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;

/*!
    @method removeCredential:forProtectionSpace:
    @abstract Remove the credential from the set for the specified protection space.
    @param credential The credential to remove.
    @param space The protection space for which a credential should be removed
    @discussion The credential is removed from both persistent and temporary storage. A credential that
    has a persistence policy of NSURLCredentialPersistenceSynchronizable will fail.  
    See removeCredential:forProtectionSpace:options.
*/
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;

/*!
 @method removeCredential:forProtectionSpace:options
 @abstract Remove the credential from the set for the specified protection space based on options.
 @param credential The credential to remove.
 @param space The protection space for which a credential should be removed
 @param options A dictionary containing options to consider when removing the credential.  This should
 be used when trying to delete a credential that has the NSURLCredentialPersistenceSynchronizable policy.
 Please note that when NSURLCredential objects that have a NSURLCredentialPersistenceSynchronizable policy
 are removed, the credential will be removed on all devices that contain this credential.
 @discussion The credential is removed from both persistent and temporary storage.
 */
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space options:(NSDictionary *)options NS_AVAILABLE(10_9, 7_0);

/*!
    @method defaultCredentialForProtectionSpace:
    @abstract Get the default credential for the specified protection space.
    @param space The protection space for which to get the default credential.
*/
- (NSURLCredential *)defaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space;

/*!
    @method setDefaultCredential:forProtectionSpace:
    @abstract Set the default credential for the specified protection space.
    @param credential The credential to set as default.
    @param space The protection space for which the credential should be set as default.
    @discussion If the credential is not yet in the set for the protection space, it will be added to it.
*/
- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space;

@end

@interface NSURLCredentialStorage (NSURLSessionTaskAdditions)
- (void)getCredentialsForProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task completionHandler:(void (^) (NSDictionary *credentials))completionHandler NS_AVAILABLE(10_10, 8_0);
- (void)setCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task NS_AVAILABLE(10_10, 8_0);
- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace options:(NSDictionary *)options task:(NSURLSessionTask *)task NS_AVAILABLE(10_10, 8_0);
- (void)getDefaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space task:(NSURLSessionTask *)task completionHandler:(void (^) (NSURLCredential *credential))completionHandler NS_AVAILABLE(10_10, 8_0);
- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)protectionSpace task:(NSURLSessionTask *)task NS_AVAILABLE(10_10, 8_0);
@end

/*!
    @const NSURLCredentialStorageChangedNotification
    @abstract This notification is sent on the main thread whenever
    the set of stored credentials changes.
*/
FOUNDATION_EXPORT NSString *const NSURLCredentialStorageChangedNotification;

/*
 *  NSURLCredentialStorageRemoveSynchronizableCredentials - (NSNumber value)
 *		A key that indicates either @YES or @NO that credentials which contain the NSURLCredentialPersistenceSynchronizable
 *		attribute should be removed.  If the key is missing or the value is @NO, then no attempt will be made
 *		to remove such a credential.
 */
FOUNDATION_EXPORT NSString *const NSURLCredentialStorageRemoveSynchronizableCredentials NS_AVAILABLE(10_9, 7_0);



