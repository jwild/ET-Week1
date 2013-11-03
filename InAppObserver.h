//
//  InAppObserver.h
//  InAppPurchase
//
//  Created by Justin's Clone on 10/29/13.
//  Copyright (c) 2013 CartoonSmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface InAppObserver : NSObject <SKPaymentTransactionObserver> {
    
    
    
}


-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;


@end
