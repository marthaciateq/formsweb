- -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 � n g e l   H e r n � n d e z  
 - -   C r e a t e   d a t e :   0 6   D i c   2 0 1 6  
 - -   D e s c r i p t i o n : 	 E s t a b l e c e   e l   e s t a t u s   f i n a l   a   u n a   e n c u e s t a   d e s p u e s   d e l   p r o c e s o   d e   d e s c a r g a  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ s p p _ f o r m s _ d o w n l o a d _ c o m m i t ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ i d F o r m D e s c a r g a   c h a r ( 3 2 )  
 A S  
 B E G I N  
 	 D E C L A R E   @ e r r o r   V A R C H A R ( M A X ) ;  
 	 D E C L A R E   @ D E S C A R G A D O   I N T   =   2 ;  
  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
 	  
 	 B E G I N   T R Y  
 	  
 	 	 - - E X E C U T E   s p _ s e r v i c i o s _ v a l i d a r       @ i d S e s s i o n ,   @ @ P R O C I D ,   @ i d U s u a r i o   O U T P U T  
 	  
 	 	 B E G I N   T R A N S A C T I O N  
 	 	  
 	 	 	 U P D A T E   f o r m s D e s c a r g a s   S E T   e s t a t u s   =   @ D E S C A R G A D O   W H E R E   i d F o r m D e s c a r g a   =   @ i d F o r m D e s c a r g a ;  
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