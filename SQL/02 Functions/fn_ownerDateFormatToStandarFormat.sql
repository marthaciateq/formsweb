- -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 J o s e   A n g e l   H e r n a n d e z  
 - -   C r e a t e   d a t e :   0 7   D i c   2 0 1 6  
 - -   D e s c r i p t i o n : 	 P a r s e a   u n a   f e c h a   e x p r e s a d a   e n   f o r m a t o   Y Y Y Y - M M - D D , H . M . S . m   a l   f o r m a t o   e s t a n d a r   Y Y Y Y - M M - D D   H : M : S : m  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   F U N C T I O N   [ d b o ] . [ f n _ o w n e r D a t e F o r m a t T o S t a n d a r F o r m a t ]    
 (  
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   f u n c t i o n   h e r e  
 	 @ o w n e r F o r m a t   V A R C H A R ( M A X )  
 )  
 R E T U R N S   V A R C H A R ( M A X )  
 A S  
 B E G I N  
 	 - -   D e c l a r e   t h e   r e t u r n   v a r i a b l e   h e r e  
 	  
 	 R E T U R N   R E P L A C E ( R E P L A C E ( R E P L A C E ( @ o w n e r F o r m a t , ' U T C : ' ,   ' ' ) ,   ' , ' ,   '   ' ) ,   ' . ' ,   ' : ' ) ;  
  
 E N D 