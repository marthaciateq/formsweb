- -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 � n g e l   H e r n � n d e z  
 - -   C r e a t e   d a t e :   2 5   N o v   2 0 1 6  
 - -   D e s c r i p t i o n : 	 I n i c i a   l a   d e s c a r g a   d e l   e s q u e m a   f o r m u l a r i o   p a r a   p o d e r   t r a b a j a r   o f f l i n e  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ s p s _ f o r m s _ d o w n l o a d ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ i d S e s s i o n   v a r c h a r ( M A X )  
 	 ,   @ i d F o r m   c h a r ( 3 2 )  
 A S  
 B E G I N  
 	 D E C L A R E   @ e r r o r             V A R C H A R ( M A X ) ;  
 	 D E C L A R E   @ i d U s u a r i o     V A R C H A R ( 3 2 ) ;  
 	 D E C L A R E   @ i d F o r m D e s c a r g a   C H A R ( 3 2 ) ;  
 	  
 	 D E C L A R E   @ I N I C I A D O   I N T   =   1  
 	 D E C L A R E   @ F A L L O   I N T   =   2  
 	  
 	 - -   1 =   i n i c i a d o   2 =   D e s c a r g a d o   3   =   F a l l o  
  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
 	 B E G I N   T R Y  
 	 	  
 	 	 E X E C U T E   s p _ s e r v i c i o s _ v a l i d a r       @ i d S e s s i o n ,   @ @ P R O C I D ,   @ i d U s u a r i o   O U T P U T  
 	 	 - -    
 	 	 E X E C U T E   s p _ r a n d o m K e y   @ i d F o r m D e s c a r g a   O U T P U T  
 	 	  
 	 	 - -   R e g i s t r a r   e l   i n t e n t o   d e   d e s c a r g a  
 	 	 I N S E R T   I N T O   f o r m s D e s c a r g a s   (   i d F o r m D e s c a r g a   ,   i d F o r m   ,   i d U s u a r i o   ,   f e c h a         ,   e s t a t u s       )  
 	 	 	 	 	 	 	 V A L U E S   (   @ i d F o r m D e s c a r g a ,   @ i d F o r m ,   @ i d U s u a r i o ,   G E T D A T E ( ) ,   @ I N I C I A D O   )  
 	 	  
 	 	 - -   D e v o l v e r   l o s   d a t o s   q u e   s e   v a n   a   d e s c a r g a r  
 	 	 S E L E C T   i d f o r m  
 	 	 	 	 ,   d e s c r i p c i o n  
 	 	 	 	 ,   e s t a t u s  
 	 	 	 	 ,   t i t u l o  
 	 	 	 	 ,   f c a d u c i d a d  
 	 	 	 	 - -   C a m p o   d e   r e f e r e n c i a  
 	 	 	 	 ,   @ i d F o r m D e s c a r g a   A S   i d F o r m D e s c a r g a  
 	 	 F R O M    
 	 	 	 [ d b o ] . [ f o r m s ]  
 	 	 W H E R E   i d F o r m   =   @ i d F o r m ;  
 	 	 	  
 	 	 - -   P r e g u n t a s  
 	 	 S E L E C T   i d F o r m E l e m e n t o  
 	 	 	 	 ,   e l e m e n t o  
 	 	 	 	 ,   d e s c r i p c i o n  
 	 	 	 	 ,   o r d e n  
 	 	 	 	 ,   r e q u e r i d o  
 	 	 	 	 ,   m i n i m o  
 	 	 	 	 ,   r o w _ n u m b e r ( )   O V E R (   O R D E R   B Y   i d F o r m E l e m e n t o   )   A S   r o w  
 	 	 I N T O   # t m p E l e m e n t o s  
 	 	 F R O M  
 	 	 	 [ d b o ] . [ f o r m s E l e m e n t o s ]  
 	 	 W H E R E  
 	 	 	 i d F o r m   =   @ i d F o r m   ;  
 	 	 	  
 	 	 	  
  
 	 	 S E L E C T   *   F R O M   # t m p E l e m e n t o s ;  
 	 	  
 	 	 - -   P o s i b l e s   R e s p u e s t a s  
 	 	 S E L E C T 	   i d F e l e m e n t o O p c i o n  
 	 	 	 	 ,   o p c i o n e s T a b l e . [ i d F o r m E l e m e n t o ]  
 	 	 	 	 ,   o p c i o n e s T a b l e . [ d e s c r i p c i o n ]  
 	 	 	 	 ,   o p c i o n e s T a b l e . [ o r d e n ]  
 	 	 F R O M  
 	 	 	 [ d b o ] . [ f e l e m e n t o s O p c i o n e s ]   A S   o p c i o n e s T a b l e  
 	 	 I n n e r   J o i n   # t m p E l e m e n t o s   A S   t m p E l e m e n t o s   O N   t m p E l e m e n t o s . i d F o r m E l e m e n t o   =   o p c i o n e s T a b l e . i d F o r m E l e m e n t o   ;  
 	 	  
 	 	  
 	 	 - -   R e s p u e s t a s  
 	 	 S E L E C T   t m p E l e m e n t o s . [ i d F o r m E l e m e n t o ]  
 	 	 	 	 ,   d b o . t r i m ( d a t a T a b l e . [ i d F e l e m e n t o O p c i o n ] )   A S   i d F e l e m e n t o O p c i o n  
 	 	 	 	 ,   d a t a T a b l e . [ d e s c r i p c i o n ]  
 	 	 	 	 ,   d a t a T a b l e . [ f e c h a ]  
 	 	 	 	 ,   d a t a T a b l e . [ i d U s u a r i o ]  
 	 	 F R O M   # t m p E l e m e n t o s   A S   t m p E l e m e n t o s  
 	 	 I n n e r   J o i n   [ d b o ] . [ e l e m e n t s D a t a ]   A S   d a t a T a b l e   O N   t m p E l e m e n t o s . i d F o r m E l e m e n t o   =   d a t a T a b l e . i d F o r m E l e m e n t o ;  
 	 	  
 	 	  
 	 	 D R O P   T A B L E   # t m p E l e m e n t o s ;  
 	 	  
 	 E N D   T R Y  
 	 B E G I N   C A T C H  
 	 	 R O L L B A C K   T R A N S A C T I O N  
 	 	 S E T   @ e r r o r   =   E R R O R _ M E S S A G E ( )  
 	 	  
 	 	 U P D A T E   f o r m s D e s c a r g a s   S E T   e s t a t u s   =   @ F A L L O   W H E R E   i d F o r m D e s c a r g a   =   @ i d F o r m D e s c a r g a ;  
 	 	  
 	 	 E X E C U T E   s p _ e r r o r   ' S ' ,   @ e r r o r  
 	 E N D   C A T C H  
 	  
 E N D  
 