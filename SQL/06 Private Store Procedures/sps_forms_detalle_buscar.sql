- -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 � n g e l   H e r n � n d e z  
 - -   C r e a t e   d a t e :   3 0   S e p   2 0 1 6  
 - -   D e s c r i p t i o n : 	 O b t i e n e   F o r m s   y   s u   d e t a l l e   p o r   m e d i o   d e l   i d  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ s p s _ f o r m s _ d e t a l l e _ b u s c a r ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ i d F o r m   c h a r ( 3 2 )  
 	 ,   @ s t a r t   i n t  
 	 ,   @ l i m i t   i n t  
 A S  
 B E G I N  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
 	 	  
 	 - -   P r e g u n t a s  
 	 S E L E C T   d b o . t r i m ( i d F o r m E l e m e n t o )   A S   i d F o r m E l e m e n t o  
 	 	 	 ,   e l e m e n t o  
 	 	 	 ,   d e s c r i p c i o n  
 	 	 	 ,   o r d e n  
 	 	 	 ,   r e q u e r i d o  
 	 	 	 ,   m i n i m o  
 	 	 	 ,   r o w _ n u m b e r ( )   O V E R (   O R D E R   B Y   i d F o r m E l e m e n t o   )   A S   r o w  
 	 I N T O   # t m p E l e m e n t o s  
 	 F R O M  
 	 	 f o r m s E l e m e n t o s  
 	 W H E R E    
 	 	 i d F o r m   =   @ i d F o r m   ;  
 	  
 	  
 	 	  
 	 S E L E C T   *    
 	 I N T O   # t m p E l e m e n t o s P a g i n a d o s  
 	 F R O M   # t m p E l e m e n t o s  
 	 W H E R E     (   [ r o w ]   >   @ s t a r t   O R     @ s t a r t   I S   N U L L   )   A N D   (   [ r o w ]   < =   @ s t a r t   +   @ l i m i t   O R   @ s t a r t   I S   N U L L   ) ;  
 	 	  
 	 S E L E C T   *   F R O M   # t m p E l e m e n t o s P a g i n a d o s ;  
 	  
 	  
 	 - -   P o s i b l e s   R e s p u e s t a s  
 	 S E L E C T 	   d b o . t r i m ( o p c i o n e s T a b l e . i d F e l e m e n t o O p c i o n )   A S   i d F e l e m e n t o O p c i o n  
 	 	 	 ,   d b o . t r i m ( o p c i o n e s T a b l e . [ i d F o r m E l e m e n t o ] )   A S   i d F o r m E l e m e n t o  
 	 	 	 ,   o p c i o n e s T a b l e . [ d e s c r i p c i o n ]  
 	 	 	 ,   o p c i o n e s T a b l e . [ o r d e n ]  
 	 F r o m  
 	 	 [ d b o ] . [ f e l e m e n t o s O p c i o n e s ]   A S   o p c i o n e s T a b l e  
 	 I N N E R   J O I N   # t m p E l e m e n t o s P a g i n a d o s   A S   t m p E l e m e n t o s   O N   t m p E l e m e n t o s . i d F o r m E l e m e n t o   =   o p c i o n e s T a b l e . i d F o r m E l e m e n t o   ;  
 	  
 	  
 	 - -   R e s p u e s t a s  
 	 S E L E C T   d b o . t r i m ( t m p E l e m e n t o s . [ i d F o r m E l e m e n t o ] )   A S   i d F o r m E l e m e n t o  
 	 	 	 ,   d b o . t r i m ( i d F e l e m e n t o O p c i o n )   A S   i d F e l e m e n t o O p c i o n  
 	 	 	 ,   d a t a T a b l e . d e s c r i p c i o n  
 	 	 	 ,   d a t a T a b l e . f e c h a  
 	 F R O M   # t m p E l e m e n t o s P a g i n a d o s   A S   t m p E l e m e n t o s  
 	 I N N E R   J O I N   [ d b o ] . [ e l e m e n t s D a t a ]   A S   d a t a T a b l e   O N   t m p E l e m e n t o s . i d F o r m E l e m e n t o   =   d a t a T a b l e . i d F o r m E l e m e n t o ;  
 	  
 	  
 	 I F   (   @ s t a r t   =   0 )   B E G I N  
 	 	 - -   E l e m e n t o s   R e q u e r i d o s ,   e s t o s   s o l o   d e b e n   e n v i a r s e   u n a   v e z   s o l a m e n t e   a l   c l i e n t e  
 	 	 S E L E C T         d b o . t r i m ( f o r m s E l e m e n t o s T a b l e . i d F o r m E l e m e n t o )   A S   i d F o r m E l e m e n t o  
 	 	 	 	 ,   C O U N T ( e l e m e n t s D a t a T a b l e . i d F o r m E l e m e n t o )       A S   n u m R e s p u e s t a s  
 	 	 	 	 ,   C A S T (   M A X (   C A S T ( r e q u e r i d o   A S   T I N Y I N T   )   )   A S   B I T   )     A S   r e q u e r i d o  
 	 	 	 	 ,   C A S T (   M A X (    
 	 	 	 	 	 	 	 C A S E   W H E N   L E N (   I S N U L L ( e l e m e n t s D a t a T a b l e . d e s c r i p c i o n ,   ' ' )   +   C A S E   W H E N   e l e m e n t s D a t a T a b l e . f e c h a   I S   N U L L   T H E N    
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 ' '    
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 E L S E    
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 C A S T ( e l e m e n t s D a t a T a b l e . f e c h a   A S   V A R C H A R ( 9 ) )    
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 E N D    
 	 	 	 	 	 	 	 	 	 	 	 )   >   0     T H E N  
 	 	 	 	 	 	 	 	 1    
 	 	 	 	 	 	 	 E L S E    
 	 	 	 	 	 	 	 	 0    
 	 	 	 	 	 	 	 E N D  
 	 	 	 	 	 	  
 	 	 	 	 	 	 )   A S   B I T   )   A S   r e s p u e s t a V a l i d a  
 	 	 	 	 ,   M A X ( [ f o r m s E l e m e n t o s T a b l e ] . m i n i m o )   A S   m i n i m o  
 	 	 F R O M   [ d b o ] . [ f o r m s E l e m e n t o s ]   A S   f o r m s E l e m e n t o s T a b l e    
 	 	 	 L E F T   J O I N   [ d b o ] . [ e l e m e n t s D a t a ]   A S   e l e m e n t s D a t a T a b l e   O N   f o r m s E l e m e n t o s T a b l e . i d F o r m E l e m e n t o   =   e l e m e n t s D a t a T a b l e . i d F o r m E l e m e n t o  
 	 	 W H E R E      
 	 	 	 i d F o r m   =   @ i d F o r m    
 	 	 G R O U P   B Y   f o r m s E l e m e n t o s T a b l e . i d F o r m E l e m e n t o ;  
 	  
 	 E N D  
 	  
 	  
 	 D R O P   T A B L E   # t m p E l e m e n t o s ;  
 	 D R O P   T A B L E   # t m p E l e m e n t o s P a g i n a d o s ;  
 	  
 	  
 E N D  
 