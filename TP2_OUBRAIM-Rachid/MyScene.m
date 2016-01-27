//
//  MyScene.m
//  TP2_OUBRAIM-Rachid
//
//  Created by OUBRAIM RACHID & LAAGAD EL MEHDI on 06/11/2014.
//  Copyright (c) 2014 OUBRAIM RACHID & LAAGAD EL MEHDI. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

SKSpriteNode *vaisseau, *vaisseauEnemi;
SKSpriteNode *rocket , *rocketEnemi;

SKLabelNode *lbl_score, *lbl_vies, *lbl_force;
SKLabelNode *lbl_Over, *lbl_start, *lbl_scoreSaved;
SKSpriteNode *bg_game, *bg_transparent;



int _score = 0;


int b_me = 1;
int b_meRocket= 4;
int b_enemi = 2;
int b_enemiRocket = 3;

int score = 0 ;
int vies = 2 ;
int force = 100;
int level = 5;
int vitesse_tir = -20.0;
float vitesse_deplace = 1.0;
float w,h;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
    
        w = size.width;
        h = size.height;
        
        //bg game
        bg_game = [SKSpriteNode spriteNodeWithImageNamed:@"bg-game"];
        bg_game.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:bg_game];
        
        //Label Score
        NSString *str_score = [[NSString alloc] initWithFormat:@"Score : %d ", score];
        lbl_score = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
        lbl_score.name = @"Score";
        lbl_score.text = str_score;
        lbl_score.color = [SKColor blackColor ];
        lbl_score.position = CGPointMake(350, 700);
        lbl_score.fontSize = 30;
        [self addChild:lbl_score];
        
        
        //Label VIES
        NSString *str_vies = [[NSString alloc] initWithFormat:@"Vie(s) : %d ", vies];
        lbl_vies = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
        lbl_vies.name = @"Vies";
        lbl_vies.text = str_vies;
        lbl_vies.color = [SKColor blackColor ];
        lbl_vies.position = CGPointMake(120, 700);
        lbl_vies.fontSize = 30;
        [self addChild:lbl_vies];
        
        //Label FORCE
        NSString *str_force = [[NSString alloc] initWithFormat:@"Force : %d ", force];
        lbl_force = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
        lbl_force.name = @"Force";
        lbl_force.text = str_force;
        lbl_force.color = [SKColor blackColor ];
        lbl_force.position = CGPointMake(700, 700);
        lbl_force.fontSize = 30;
        [self addChild:lbl_force];
    
        
        //self.backgroundColor = [SKColor whiteColor ];
       
        vaisseau = [SKSpriteNode spriteNodeWithImageNamed:@"user"];
        vaisseau.position = CGPointMake(CGRectGetMidX(self.frame)-300, CGRectGetMidY(self.frame));
        vaisseau.name = @"vaisseau" ;
        vaisseau.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(64.0, 64.0) ];
        vaisseau.physicsBody.dynamic = NO;
        vaisseau.physicsBody.contactTestBitMask  = b_me ;
        
        vaisseauEnemi = [SKSpriteNode spriteNodeWithImageNamed:@"ennemie"];
        vaisseauEnemi.position = CGPointMake(CGRectGetMidX(self.frame)+300,  CGRectGetMidY(self.frame));
        vaisseauEnemi.name = @"vaisseauEnemi" ;
        vaisseauEnemi.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(64.0, 64.0) ];
        vaisseauEnemi.physicsBody.dynamic = NO;
        vaisseauEnemi.physicsBody.contactTestBitMask = b_enemi ;
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        
        [self addChild:vaisseau];
        [self addChild:vaisseauEnemi];
        [self deplacerEnemi];
        
        
    }
    return self;
}

-(void) deplacerEnemi{
    int maxY = (int)self.frame.size.height;
    double y = (double)(arc4random() % maxY);
    SKAction *action = [SKAction moveTo:CGPointMake(vaisseauEnemi.position.x, y) duration:vitesse_deplace];
    SKAction *rec = [SKAction runBlock:^(void) {[self deplacerEnemi];}];
    SKAction *seq = [SKAction sequence:[NSArray arrayWithObjects:action,rec, nil]];
    [vaisseauEnemi runAction:seq];
    [self lancerRocketsEnemi];
}


-(void) lancerRocketsEnemi{
    rocketEnemi = [SKSpriteNode spriteNodeWithImageNamed:@"like"];
    
    rocketEnemi.position = CGPointMake(vaisseauEnemi.position.x-80, vaisseauEnemi.position.y);
    rocketEnemi.physicsBody.dynamic = YES ;
    rocketEnemi.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30.0, 30.0) ];
    rocketEnemi.physicsBody.contactTestBitMask = b_enemiRocket ;
    
    
    [self addChild:rocketEnemi];
    
    [rocketEnemi.physicsBody applyImpulse:CGVectorMake(vitesse_tir, 0)];
    
    
}


-(void) lancerRockets{
    
    rocket = [SKSpriteNode spriteNodeWithImageNamed:@"tweet"];
    
    rocket.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30.0, 30.0) ];
    rocket.physicsBody.contactTestBitMask = b_meRocket;
    rocket.physicsBody.dynamic = YES ;
    
    rocket.position = CGPointMake(vaisseau.position.x+90,vaisseau.position.y);
    
    [self addChild:rocket];
    [rocket.physicsBody applyImpulse:CGVectorMake(100, 0)];
}


- (void)keyDown:(NSEvent *)theEvent {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    
    unichar keyChar = [theEvent keyCode];
    SKAction *action ;
    SKNode *n;
    n = [self childNodeWithName:@"vaisseau"] ;
    
    if(keyChar == 124 ) {
        //droit
        if (n.position.x+n.frame.size.width < self.frame.size.width/2 ){
            action = [SKAction moveByX:40 y:0.0 duration:0.1 ];
        }
        
        
    }else if(keyChar == 123){
        //gauche
        if (n.position.x > n.frame.size.width ){
            action = [SKAction moveByX:-40 y:0.0 duration:0.1 ];
        }
        
    }else if (keyChar == 126) {
        if (n.position.y <  self.frame.size.height-64 ){
            action = [SKAction moveByX:0 y:50.0 duration:0.1 ];
        }
    }else if (keyChar == 125) {
        //bas
        if (n.position.y > n.frame.size.height ){
            action = [SKAction moveByX:0 y:-50.0 duration:0.1 ];
        }
    }else if (keyChar == 49) {
        //bas
        [self lancerRockets];
    }else if (keyChar == 36 ) {
        //space
        [self restartGame];
    }
    
    [n runAction:action];
    
}


-(void)restartGame{
    
    
    lbl_Over.text = @" ";
    lbl_start.text = @" ";
    lbl_scoreSaved.text = @" ";
    
    score = 0 ;
    NSString *str_score = [[NSString alloc] initWithFormat:@"Score : %d ", score];
    lbl_score.text =  str_score;
    
    
    vies = 2 ;
    vitesse_deplace = 1;
    vitesse_tir = -20 ;
    NSString *str_vie = [[NSString alloc] initWithFormat:@"Vie(s) : %d ", vies];
    lbl_vies.text =  str_vie;
    
    [bg_transparent removeFromParent];

}

-(void) gameOver{
    
    NSString *gOver = [[NSString alloc] initWithFormat:@"GAME OVER " ];
    lbl_Over = [SKLabelNode labelNodeWithFontNamed:@"helvetica"];
    
    lbl_Over.name = @"gameover";
    lbl_Over.text = gOver;
    
    
    lbl_Over.color = [SKColor blackColor ];
    lbl_Over.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    lbl_Over.fontSize = 50;
    
    /*for (SKNode *n in self.children) {
        [n removeFromParent];
    }
    */
    
    bg_transparent = [[SKSpriteNode alloc ] initWithColor:[NSColor blackColor]  size:CGSizeMake(w,h)];
    bg_transparent.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bg_transparent];
    
    [self addChild:lbl_Over];
    
    NSString *gl = [[NSString alloc] initWithFormat:@"Press Enter to restart  " ];
    lbl_start = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
    
    lbl_start.name = @"start";
    lbl_start.text = gl;
    lbl_start.color = [SKColor blackColor ];
    lbl_start.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-300);
    lbl_start.fontSize = 30;
    [self addChild:lbl_start];
    
    NSString *result_score = [[NSString alloc] initWithFormat:@"Score Obtenu : %d ", score];
    lbl_score.text =  result_score;
    lbl_scoreSaved = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
    lbl_scoreSaved.text = result_score;
    lbl_scoreSaved.color = [SKColor blackColor ];
    lbl_scoreSaved.position =  CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-200);
    lbl_scoreSaved.fontSize = 30;
    [self addChild:lbl_scoreSaved];
   
}




-(void) didBeginContact:(SKPhysicsContact *)contact{
    
     if(contact.bodyA.contactTestBitMask != contact.bodyB.contactTestBitMask){
       
         
         if (contact.bodyB.contactTestBitMask == b_enemiRocket){
             force -= 10;
             if(force == 0 ){
                 vies--;
                 force = 100;
             }
             NSString *str_newVies = [[NSString alloc] initWithFormat:@"Vie(s) : %d ", vies];
             lbl_vies.text =  str_newVies;
             
             NSString *str_newForce = [[NSString alloc] initWithFormat:@"Force : %d ", force];
             lbl_force.text =  str_newForce;
             
             if(vies==0) [self gameOver];
             [contact.bodyB.node removeFromParent];

         }
         if (contact.bodyB.contactTestBitMask == b_meRocket){
             
             score++;
             NSString *str_newScore = [[NSString alloc] initWithFormat:@"Score : %d ", score];
             lbl_score.text =  str_newScore;
             if(score == level){
                 vitesse_tir -= 10.0;
                 level += 5;
                 if(vitesse_deplace > 0.0)
                     vitesse_deplace -= 0.1;
             }
             [contact.bodyB.node removeFromParent];
         }
         
         
          if ((contact.bodyB.contactTestBitMask == b_enemiRocket && contact.bodyA.contactTestBitMask == b_meRocket)
              || (contact.bodyA.contactTestBitMask == b_enemiRocket && contact.bodyB.contactTestBitMask == b_meRocket )){
             // contact entre deux missiles
             [contact.bodyB.node removeFromParent];
             [contact.bodyA.node removeFromParent];
         }
         
     }
    
    
}



-(void)mouseDown:(NSEvent *)theEvent {
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

@end
