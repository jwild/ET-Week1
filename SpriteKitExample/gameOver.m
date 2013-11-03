//
//  gameOver.m
//  SpriteKitExample
//
//  Created by Claude Wild on 11/3/13.
//  Copyright (c) 2013 Claude Wild. All rights reserved.
//

#import "gameOver.h"
#import "Home.h"

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
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:5.0],
                              [SKAction runBlock:^{
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[Home alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];
        
    }
    return self;
}

@end