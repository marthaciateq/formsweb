- -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 � n g e l   H e r n � n d e z  
 - -   C r e a t e   d a t e :   0 6   O c t   2 0 1 6  
 - -   D e s c r i p t i o n : 	 O b t i e n e   u n   l i s t a d o   d e   l o s   f o r m s   q u e   t i e n e   a s i g n a d o s   e l   u s u a r i o  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ s p s _ f o r m s _ l i s t a r ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	     @ i d S e s s i o n   v a r c h a r ( M A X )  
 	 ,   @ s t a r t   i n t  
 	 ,   @ l i m i t   i n t  
 A S  
 B E G I N  
 	 D E C L A R E   @ i d U s u a r i o   V A R C H A R ( M A X ) ;  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
 	 D E C L A R E   @ e r r o r   V A R C H A R ( M A X )  
 	  
 	 B E G I N   T R Y  
 	  
 	 	 E X E C U T E   s p _ s e r v i c i o s _ v a l i d a r   @ i d S e s s i o n ,   @ @ P R O C I D ,   @ i d U s u a r i o   O U T P U T ;  
  
 	 	 - -   F o r m u l a r i o  
 	 	 S E L E C T         f o r m s T a b l e . i d F o r m  
 	 	 	 	 ,   d e s c r i p c i o n  
 	 	 	 	 ,   f o r m s T a b l e . e s t a t u s  
 	 	 	 	 ,   t i t u l o  
 	 	 	 	 ,   f c a d u c i d a d   A S   f C a d u c i d a d  
 	 	 	 	 ,   f o r m s U s u a r i o s T a b l e . f i n a l i z a d o  
 	 	 	 	 ,   n o m b r e s   +   '   '   +   a p a t e r n o   +   '   '   +   a m a t e r n o   A S   n o m b r e C o m p l e t o C r e o  
 	 	 	 	 ,   R O W _ N U M B E R ( )   O V E R (   O R D E R   B Y   f o r m s T a b l e . i d F o r m   )   A S   r o w  
 	 	 	 	 ,   (   S E L E C T   C O U N T ( i d f o r m E l e m e n t o )   A S   n u m E l e m e n t o s   F R O M   f o r m s E l e m e n t o s   W H E R E   i d F o r m   =   f o r m s T a b l e . i d F o r m )   A S   n u m E l e m e n t o s  
 	 	 	 	 ,   (   S E L E C T   M A X ( f e c h a )   F R O M   f o r m s D e s c a r g a s   W H E R E   i d F o r m   =   f o r m s T a b l e . i d F o r m   A N D   i d U s u a r i o   =   @ i d U s u a r i o )   A S   f e c h a D e s c a r g a    
 	 	 	 	 ,   m i n i m o  
 	 	 I N T O   # t m p F o r m s  
 	 	 F R O M    
 	 	 	 [ d b o ] . [ f o r m s ]   A S   f o r m s T a b l e  
 	 	 	 I N N E R   J O I N   [ d b o ] . [ b f o r m s ]   A S   b i t a c o r a T a b l e   O N   b i t a c o r a T a b l e . i d F o r m   =   f o r m s T a b l e . i d F o r m  
 	 	 	 I N N E R   J O I N   [ d b o ] . [ u s u a r i o s ]   A S   u s u a r i o s T a b l e   O N   b i t a c o r a T a b l e . i d U s u a r i o   =   u s u a r i o s T a b l e . i d U s u a r i o  
 	 	 	 I N N E R   J O I N   [ d b o ] . [ f o r m s U s u a r i o s ]   A S   f o r m s U s u a r i o s T a b l e   O N   f o r m s T a b l e . i d F o r m   =   f o r m s U s u a r i o s T a b l e . i d F o r m  
 	 	 W H E R E  
 	 	 	 f o r m s U s u a r i o s T a b l e . i d U s u a r i o   =   @ i d U s u a r i o     A N D   f o r m s U s u a r i o s T a b l e . f i n a l i z a d o   =   0 ;  
 	 	 	  
  
 	 	 	  
 	 	 - -   P a g i n a c i � n  
 	 	 S E L E C T   *    
 	 	 F R O M   # t m p F o r m s  
 	 	 W H E R E   (   [ r o w ]   >   @ s t a r t   O R     @ s t a r t   I S   N U L L   )   A N D   (   [ r o w ]   < =   @ s t a r t   +   @ l i m i t   O R   @ s t a r t   I S   N U L L   ) ;  
 	 	 	  
 	 	 	  
 	 	 D R O P   T A B L E   # t m p F o r m s ;  
 	  
 	  
 	 E N D   T R Y  
 	 B E G I N   C A T C H  
 	 	 S E T   @ e r r o r   =   e r r o r _ m e s s a g e ( )  
 	 	 E X E C U T E   s p _ e r r o r   ' S ' ,   @ e r r o r  
 	 E N D   C A T C H  
 	  
 E N D  
 