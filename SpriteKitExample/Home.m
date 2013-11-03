//
//  Home.m
//  SpriteKitExample
//
//  Created by Claude Wild on 11/3/13.
//  Copyright (c) 2013 Claude Wild. All rights reserved.
//

#import "Home.h"
#import "MyScene.h"

@implementation Home

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //WOO title and labels!
        NSString * welcomeMsg = @"Welcome to Soldier Escape!";
        NSString * gameMsg = @"Don't let the soldiers excape!";
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
        label.text = welcomeMsg;
        label.fontSize = 20;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2+30);
        [self addChild:label];
        
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
        label2.text = gameMsg;
        label2.fontSize = 15;
        label2.fontColor = [SKColor blackColor];
        label2.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label2];
        
        //button to start game
        [self addChild: [self buttonNode]];
        
    }
    return self;
}

- (SKSpriteNode *)buttonNode
{
    SKSpriteNode *buttonNode = [SKSpriteNode spriteNodeWithImageNamed:@"button"];
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
        
        //on click of button, move to game.
        [self runAction:
         [SKAction sequence:@[
                              [SKAction runBlock:^{
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];

    }
}


@end
