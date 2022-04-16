(DEFUN c:offsets()
(setq l 0)


(setq f (open "D:\\coords.txt" "W"))  


  (while (<= l 9)
	(setq a (getpoint "enter points"))
	(princ a)
	
	(setq y (car a))


	(prin1 y f)

(princ "\n" f)

  
(setq l (1+ l))
)

(CLOSE f)
(princ "over")

)