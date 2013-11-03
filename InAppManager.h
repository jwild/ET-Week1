//
//  InAppManager.h
//  InAppPurchase
//
//  Created by Justin's Clone on 10/29/13.
//  Copyright (c) 2013 CartoonSmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "InAppObserver.h"

@interface InAppManager : NSObject <SKProductsRequestDelegate> {
    
    
    
}


+(InAppManager*) sharedManager;


-(void) buyFeature1; // declared so any class call this and initiate purchasing Product 1
-(void) buyFeature2; // declared so any class call this and initiate purchasing Product 2
-(void) buyFeature3; // declared so any class call this and initiate purchasing Product 3

-(bool) isFeature1PurchasedAlready; // declared so any class can check if Product 1 was purchased prior to doing something
-(bool) isFeature2PurchasedAlready; // declared so any class can check if Product 2 was purchased prior to doing something
-(bool) isFeature3PurchasedAlready; // declared so any class can check if Product 3 was purchased prior to doing something

-(void) restoreCompletedTransactions; // if you sell non-consumable purchases you MUST give people the option to RESTORE.

-(void) failedTransaction:(SKPaymentTransaction*) transaction;
-(void) provideContent:(NSString*) productIdentifier; 

@end
