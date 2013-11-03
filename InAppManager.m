//
//  InAppManager.m
//  InAppPurchase
//
//  Created by Justin's Clone on 10/29/13.
//  Copyright (c) 2013 CartoonSmart. All rights reserved.
//

#import "InAppManager.h"


@interface InAppManager () {
    
    NSMutableArray* purchaseableProducts; // an array of possible products to purchase
    NSUserDefaults* defaults; // store a bool variable marking products that have been unlocked
    bool product1WasPurchased; // YES or NO
    bool product2WasPurchased; // YES or NO
    bool product3WasPurchased; // YES or NO
    
    InAppObserver* theObserver;
    
}

@end



@implementation InAppManager

static NSString* productID1 = @"BUY_EXTRA_LIFE";
static NSString* productID2 = @"NOTSET";
static NSString* productID3 = @"NOTSET";

static InAppManager* sharedManager = nil;

+(InAppManager*) sharedManager {
    
    if(sharedManager == nil) {
        
        sharedManager = [[InAppManager alloc] init];
        
    }
    
    return sharedManager;
}

-(id) init {
    
    if  ((self = [super init])) {
        
        //do initialization
        
        sharedManager = self;
        defaults = [NSUserDefaults standardUserDefaults]; //use the standard user defaults
        product1WasPurchased = [defaults boolForKey:productID1]; //will be NO by default (on first run)
        product2WasPurchased = [defaults boolForKey:productID2]; //will be NO by default (on first run)
        product3WasPurchased = [defaults boolForKey:productID3]; //will be NO by default (on first run)
        
        purchaseableProducts = [[NSMutableArray alloc] init];
        [self requestProductData]; // as soon as we initialize the class, we want to get product info from the store
        
        theObserver = [[InAppObserver alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:theObserver];
    }
    
    return self;
    
}

-(void) requestProductData {
    
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:productID1, productID2, productID3, nil]]; //ad  more products in the NSSet if you need them
    
    request.delegate = self;
    [request start];
}


-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    //add more here later
    
    NSArray* skProducts = response.products; // skProducts array will equal the array that comes back
   // NSLog(@"This is a vague response, but you should get one... %@", skProducts);
    
    if ( [skProducts count] != 0 && [purchaseableProducts count] == 0) {
        
        for (int i = 0; i < [skProducts count]; i++) {
            
            [purchaseableProducts addObject:[skProducts objectAtIndex:i]];
            SKProduct* product = [purchaseableProducts objectAtIndex:i];
            
            NSLog(@"Feature: %@, Cost: %f, ID: %@", [product localizedTitle], [[product price] doubleValue], [product productIdentifier] );
            
        }
        
    }
    NSLog(@" We found %lu In-App Purchases in iTunes Connect", (unsigned long)[purchaseableProducts count]);
    
}


-(void) failedTransaction:(SKPaymentTransaction*) transaction{
    
    NSString* failMessage = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]  ];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:failMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
}
-(void) provideContent:(NSString*) productIdentifier{
    
    
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter]; // used below to post notifications
    NSString* theMessageForAlert;
    
    if ( [productIdentifier isEqualToString:productID1]) {
        theMessageForAlert = @"Your App now has product 1's content available";
        product1WasPurchased = YES;
        [defaults setBool:YES forKey:productID1];
        [notification postNotificationName:@"feature1Purchased" object:nil];
        
        
    } else if ( [productIdentifier isEqualToString:productID2]) {
        theMessageForAlert = @"Your App now has product 2's content available";
        product2WasPurchased = YES;
        [defaults setBool:YES forKey:productID2];
        [notification postNotificationName:@"feature2Purchased" object:nil];
    
    }  else if ( [productIdentifier isEqualToString:productID3]) {
        theMessageForAlert = @"Your App now has product 3's content available";
        product3WasPurchased = YES;
        [defaults setBool:YES forKey:productID3];
        [notification postNotificationName:@"feature3Purchased" object:nil];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!" message:theMessageForAlert delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}


-(void) buyFeature1 {
    
    [self buyFeature:productID1];
    
}
-(void) buyFeature2 {
    
    [self buyFeature:productID2];
    
}
-(void) buyFeature3 {
    
    [self buyFeature:productID3];
    
}

-(void) buyFeature:(NSString*) featureID {
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"Can make payments");
        SKProduct* selectedProduct;
        
        for (int i=0; i < [purchaseableProducts count]; i++) {
            selectedProduct = [purchaseableProducts objectAtIndex:i];
            
            if ([[selectedProduct productIdentifier] isEqualToString:featureID ]) {
                
                // if we found a SKProduct in the purchaseableProducts array with the same ID as the one we want to buy, we proceed by putting it in the payment queue.
                
                SKPayment* payment = [SKPayment paymentWithProduct:selectedProduct];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
                break;
                
            }
            
        }
    
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no" message:@"You can't purchase from the App Store" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(bool) isFeature1PurchasedAlready {
    
    return product1WasPurchased;
}
-(bool) isFeature2PurchasedAlready {
    
     return product2WasPurchased;
    
}
-(bool) isFeature3PurchasedAlready {
    
    return product3WasPurchased;
    
}

-(void) restoreCompletedTransactions{
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}



@end
