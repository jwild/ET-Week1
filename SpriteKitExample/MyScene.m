#import "MyScene.h"
#import "gameOver.h"
static const uint32_t holeCategory     =  0x1 << 0;
static const uint32_t soldierCategory        =  0x1 << 1;
@import AVFoundation;

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * tank;
@property (nonatomic) SKSpriteNode * field;
@property (nonatomic) int score;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end

@implementation MyScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
       
        
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        //add my background field
        self.field =[SKSpriteNode spriteNodeWithImageNamed:@"field"];
        self.field.position = CGPointMake(240, 160);
        [self addChild:self.field];
        //add my tank
        self.tank = [SKSpriteNode spriteNodeWithImageNamed:@"tank"];
        self.tank.position = CGPointMake(20, 160);
        [self addChild:self.tank];
        //turn on physics so bullet can collide
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
       
        
        //track the score of how many bad guys killed
        /*
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = @"Your Score: ";
        label.fontSize = 20;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(100, 20);
        [self addChild:label];
        
        SKLabelNode *sc = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        sc.text = @"0";
        sc.fontSize = 20;
        sc.fontColor = [SKColor blackColor];
        sc.position = CGPointMake(180, 20);
        [self addChild:sc];
        */
    }
    return self;
}



- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    //timer so we spawn a soldier every time it goes over 1 second
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self createSoldier];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    //event fires every frame
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"i like pie");
    //on touch event ending, add a hole and give it physicsbody for collision test with soldier
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKSpriteNode * hole = [SKSpriteNode spriteNodeWithImageNamed:@"hole"];
    hole.position = location;
    [self addChild:hole];
    
    hole.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hole.size.width/2];
    hole.physicsBody.dynamic = YES;
    hole.physicsBody.categoryBitMask = holeCategory;
    hole.physicsBody.contactTestBitMask = soldierCategory;
    hole.physicsBody.collisionBitMask = 0;
    hole.physicsBody.usesPreciseCollisionDetection = YES;
    
    //SKAction * selfRemove = [SKSpriteNode deactivateHole];
    //[hole runAction:[SKAction sequence:@[selfRemove]]];
}

- (void)deactivateHole{
    //hole.physicsBody = nil;
}


- (void)hole:(SKSpriteNode *)hole didCollideWithSoldier:(SKSpriteNode *)soldier {
    NSLog(@"Hit");
    hole.physicsBody = nil;
    [soldier removeFromParent];
    //set win condition, after 5 soldiers, win game
    self.score++;
    if (self.score > 4) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[gameOver alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    //collision test pulled from SK guide and tutorials
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
  
    if ((firstBody.categoryBitMask & holeCategory) != 0 &&
        (secondBody.categoryBitMask & soldierCategory) != 0){
        [self hole:(SKSpriteNode *) firstBody.node didCollideWithSoldier:(SKSpriteNode *) secondBody.node];
    }
}

- (void)createSoldier{
    //create soldier
    SKSpriteNode * soldier = [SKSpriteNode spriteNodeWithImageNamed:@"soldier"];
   //place randomly on right side of board
    int minY = soldier.size.height / 2;
    int maxY = self.frame.size.height - soldier.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    //add to stage
    soldier.position = CGPointMake(self.frame.size.width + soldier.size.width/2, actualY);
    [self addChild:soldier];
    
    //give physics body for collision testing
    soldier.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:soldier.size];
    soldier.physicsBody.dynamic = YES;
    soldier.physicsBody.categoryBitMask = soldierCategory;
    soldier.physicsBody.contactTestBitMask = holeCategory;
    soldier.physicsBody.collisionBitMask = 0;
    
    SKAction * chkGameStatus = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * GameOverView = [[gameOver alloc] initWithSize:self.size won:NO];
        [self.view presentScene:GameOverView transition: reveal];
    }];
    
    int minDuration = 1.0;
    int maxDuration = 3.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    //move the soldier
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-soldier.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [soldier runAction:[SKAction sequence:@[actionMove, chkGameStatus, actionMoveDone]]];
    
}

@end