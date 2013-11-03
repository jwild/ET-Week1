//
//  gameOver.m
//  SpriteKitExample
//
//  Created by Claude Wild on 11/3/13.
//  Copyright (c) 2013 Claude Wild. All rights reserved.
//

#import "gameOver.h"
#import "Home.h"
#import "InAppManager.h"

@implementation gameOver

-(id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"You Let One Escape!!";
        }
        NSString * buyMsg = @"Play again for ONLY $1.99!";
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2+30);
        [self addChild:label];
        
        SKLabelNode *buyLbl = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
        buyLbl.text = buyMsg;
        buyLbl.fontSize = 20;
        buyLbl.fontColor = [SKColor blackColor];
        buyLbl.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:buyLbl];
        
        [self addChild: [self buttonNode]];
        
        [InAppManager sharedManager];
        
        
        //after displaying label, wait a few second the ngo back to start screen
       /* [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:5.0],
                              [SKAction runBlock:^{
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[Home alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];
        */
        
    }
    return self;
}

- (SKSpriteNode *)buttonNode
{
    SKSpriteNode *buttonNode = [SKSpriteNode spriteNodeWithImageNamed:@"button2"];
    buttonNode.position = CGPointMake(240,100);
    buttonNode.name = @"buttonNode";
    buttonNode.zPosition = 1.0;
    return buttonNode;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"buttonNode"]) {
        NSLog(@"button clicked");
        
        [[InAppManager sharedManager] buyFeature1];
        
        //on click of button, move to game.
        [self runAction:
         [SKAction sequence:@[
                              [SKAction runBlock:^{
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[Home alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];
        
    }
}

@end