- -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 � n g e l   H e r n � n d e z  
 - -   C r e a t e   d a t e :   3 0   S e p   2 0 1 6  
 - -   D e s c r i p t i o n : 	 G u a r d a   l a s   r e s p u e s t a s   d e   l a   e n c u e s t a  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ s p s _ f o r m s _ g u a r d a r ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	     @ i d S e s s i o n   V A R C H A R ( M A X )  
 	 ,   @ i d F o r m         C H A R ( 3 2 )  
 	 ,   @ d a t o s           V A R C H A R ( M A X )  
 	 ,   @ f i n a l i z a r   B I T   =   0  
 A S  
 B E G I N  
 	 D E C L A R E   @ e r r o r   V A R C H A R ( M A X ) ;  
 	 D E C L A R E   @ i d U s u a r i o   V A R C H A R ( 3 2 ) ;  
 	 D E C L A R E   @ U P D A T E   C H A R ( 1 )   =   ' U ' ;  
 	 D E C L A R E   @ D E L E T E   C H A R ( 1 )   =   ' D ' ;  
 	 D E C L A R E   @ N E W         C H A R ( 1 )   =   ' N ' ;  
 	  
  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
 	  
 	 B E G I N   T R Y  
 	  
 	 	 E X E C U T E   s p _ s e r v i c i o s _ v a l i d a r       @ i d S e s s i o n ,   @ @ P R O C I D ,   @ i d U s u a r i o   O U T P U T  
 	  
 	 	 B E G I N   T R A N S A C T I O N  
 	 	  
 	 	 	 S E L E C T         c o l 1   A S   i d F e l e m e n t o O p c i o n  
 	 	 	 	 	 ,   c o l 2   A S   i d F o r m E l e m e n t o  
 	 	 	 	 	 ,   c o l 3   A S   d e s c r i p c i o n  
 	 	 	 	 	 ,   C A S T ( d b o . o w n e r D a t e F o r m a t T o S t a n d a r F o r m a t ( c o l 4 )   A S   D A T E T I M E )   A S   f e c h a  
 	 	 	 	 	 ,   c o l 5   A S   [ a c t i o n ]  
 	 	 	 I N T O   # t m p U s e r D a t a T a b l e  
 	 	 	 F R O M   f n _ t a b l e ( 5 ,   @ d a t o s )   A S   u s e r D a t a T a b l e  
 	 	 	 W H E R E   c o l 5   < >   ' ' ;  
 	 	 	  
  
 	 	 	 U P D A T E    
 	 	 	 	 e l e m e n t s D a t a T a b l e  
 	 	 	 S E T  
 	 	 	 	 e l e m e n t s D a t a T a b l e . d e s c r i p c i o n   =   t m p U s e r D a t a T a b l e . d e s c r i p c i o n  
 	 	 	 	 ,   e l e m e n t s D a t a T a b l e . f e c h a   =   C A S E   W H E N   t m p U s e r D a t a T a b l e . f e c h a   =   ' '   T H E N   N U L L   E L S E   t m p U s e r D a t a T a b l e . f e c h a   E N D  
 	 	 	 F R O M   [ d b o ] . [ e l e m e n t s D a t a ]     A S   e l e m e n t s D a t a T a b l e  
 	 	 	 	 I N N E R   J O I N   # t m p U s e r D a t a T a b l e   A S   t m p U s e r D a t a T a b l e   O N   e l e m e n t s D a t a T a b l e . i d F o r m E l e m e n t o   =   t m p U s e r D a t a T a b l e . i d F o r m E l e m e n t o  
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 A N D   e l e m e n t s D a t a T a b l e . i d F e l e m e n t o O p c i o n   =   t m p U s e r D a t a T a b l e . i d F e l e m e n t o O p c i o n  
 	 	 	 W H E R E   t m p U s e r D a t a T a b l e . [ a c t i o n ]   =   @ U P D A T E   A N D   e l e m e n t s D a t a T a b l e . i d U s u a r i o   =   @ i d U s u a r i o ;  
 	 	 	  
 	 	 	  
 	 	 	 D E L E T E   e l e m e n t s D a t a T a b l e  
 	 	 	 F R O M  
 	 	 	 	 [ d b o ] . [ e l e m e n t s D a t a ]   A S   e l e m e n t s D a t a T a b l e  
 	 	 	 	 I N N E R   J O I N   # t m p U s e r D a t a T a b l e   A S   t m p U s e r D a t a T a b l e   O N   e l e m e n t s D a t a T a b l e . i d F o r m E l e m e n t o   =   t m p U s e r D a t a T a b l e . i d F o r m E l e m e n t o  
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 A N D   e l e m e n t s D a t a T a b l e . i d F e l e m e n t o O p c i o n   =   t m p U s e r D a t a T a b l e . i d F e l e m e n t o O p c i o n  
 	 	 	 W H E R E   t m p U s e r D a t a T a b l e . [ a c t i o n ]   =   @ D E L E T E   A N D   e l e m e n t s D a t a T a b l e . i d U s u a r i o   =   @ i d U s u a r i o ;  
 	 	 	  
 	 	 	  
 	 	 	 I N S E R T   I N T O   [ d b o ] . [ e l e m e n t s D a t a ] ( i d F o r m E l e m e n t o ,   i d F e l e m e n t o O p c i o n ,   d e s c r i p c i o n ,   f e c h a ,   i d U s u a r i o )  
 	 	 	 S E L E C T   i d F o r m E l e m e n t o ,   i d F e l e m e n t o O p c i o n ,   d e s c r i p c i o n ,     C A S E   W H E N   f e c h a   =   ' '   T H E N   N U L L   E L S E   f e c h a   E N D ,   @ i d U s u a r i o  
 	 	 	 F R O M   # t m p U s e r D a t a T a b l e  
 	 	 	 W H E R E   [ a c t i o n ]   =   @ N E W ;  
 	 	 	  
 	 	 	 D R O P   T A B L E   # t m p U s e r D a t a T a b l e ;  
 	 	 	  
 	 	 	 I F   (   @ f i n a l i z a r   =   1   )  
 	 	 	 	 U P D A T E   [ d b o ] . [ f o r m s U s u a r i o s ]   S E T   f i n a l i z a d o   =   1       W H E R E       i d F o r m   =   @ i d F o r m       A N D       i d U s u a r i o   =   @ i d U s u a r i o ;  
 	 	 	  
 	 	  
 	 	 C O M M I T   T R A N S A C T I O N  
 	  
 	 E N D   T R Y  
 	 B E G I N   C A T C H  
 	 	 R O L L B A C K   T R A N S A C T I O N  
 	 	 S E T   @ e r r o r   =   E R R O R _ M E S S A G E ( )  
 	 	 E X E C U T E   s p _ e r r o r   ' S ' ,   @ e r r o r  
 	 E N D   C A T C H  
 	 - -    
 E N D  
 