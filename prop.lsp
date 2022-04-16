
(defun c:propeller ()

(LOAD "MARGIN")

(setq d (getreal "Enter diameter of propeller: "))
(if (= d nil) 
	(setq d savedd)
)
(setq savedd d)

(if (<= d 0)
	(error_handling)
)


(setq r (/ d 2))







(setq p_d (getreal "Enter pitch/dia ratio of propeller: "))
(if (= p_d nil) 
	(setq p_d savep_d)
)
(setq savep_d p_d)


(setq p (* p_d d))



(setq exp_ratio (getreal "Enter Expanded Blade area ratio of propeller: "))
(if (= exp_ratio nil) 
	(setq exp_ratio savedexp_ratio)
)
(setq savedexp_ratio exp_ratio)

 
(setq bl_length (* 0.5467 exp_ratio d))



(setq rake (getreal "Enter rake of propeller in degrees: "))
(if (= rake nil) 
	(setq rake savedrake)
)
(setq savedrake rake)



(setq orgin (getpoint "Click point to draw propeller:"))
(if (= orgin nil) 
	(setq orgin savedorgin)
)
(setq savedorgin orgin)


(initialise)

;;;;;;;;; Getting x y

(setq orgx (getx orgin))
(setq orgy (gety orgin))

      
(setq center (makecoord 0 0))



;;;moving center

(command "ucs" orgin "")

(margin)
(draw_1)

(command "ucs" (makecoord (* -1 d) 0) "")

(draw_2)


(command "ucs" (makecoord (* -1 d) 0) "")

(draw_3)


(command "ucs" (makecoord (* -1 d) 0) "")

(draw_4)

;;
;;;;Returning center

(command "ucs" (makecoord d 0) "")
(command "ucs" (makecoord d 0) "")
(command "ucs" (makecoord d 0) "")

(setq orgin (makecoord (* orgx -1) (* orgy -1)))
  
(command "ucs" orgin "")






(command "Zoom" "E")

(deinitialise)


)










(defun draw_1 ()


;;;;;;;;;DRAWING GRID;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(command "Circle" center "d" (* 0.2 d))
	(command "Line" center (makecoord 0 r) "")
	(setq linex (/ r 2)) 
	(setq liney (* 0.2 r))
	(setq tr nil)
 		 
		(while tr
  		  (setq pnt1 (makecoord linex liney))
  		  (setq pnt2 (makecoord (* -1 linex) liney))
  		  (command "Line" pnt1 pnt2 "")
 		 (setq liney (+ liney (* 0.1 r)))
   			(if (>= liney r)(setq tr nil)) 
  		 )




;;;;;;;;;;;DRAWING BLADE PROJECTED OUTLINE;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq offsetfile_1 (open "D:/bladelength.txt" "r"))
(setq flag 1)
(setq liney (* 0.2 r))
(Command "spline")
(while flag

	(setq val1 (read-line offsetfile_1))
	(setq val2 (* 0.01 (atof val1)))
	(setq projectedx (* val2 bl_length))
	(Command (makecoord projectedx liney))
  	(setq liney (+ liney (* 0.1 r)))
   			(if (>= liney (* 1.05 r))(setq flag nil)) 

)

(setq flag 1)
(setq liney (* 0.9 r))

(while flag

	(setq val1 (read-line offsetfile_1))
	(setq val2 (* 0.01 (atof val1)))
	(setq projectedx (* val2 bl_length))
	(Command (makecoord projectedx liney))
  	(setq liney (- liney (* 0.1 r)))
   			(if (<= liney (* 0.15 r))(setq flag nil))
	
)



(Command "" "" "")

(close offsetfile_1)



;;;;;;;;;;;;;;;FINDING TOTAL LENGTHS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq length_te_pc (read2array "d:/bladelength.txt" 0 8))
(setq length_le_pc (read2array "d:/bladelength.txt" 9 8))
(setq length_le_pc (reverse length_le_pc))
(setq i 0)
(setq lengths '(0))
(setq length_te '(0))
(setq length_le '(0))
(Repeat 8
	
	(setq lte_pc (* -1 (nth i length_te_pc)))
	(setq lle_pc (nth i length_le_pc))

	(setq lte (* 0.01 lte_pc bl_length))
	(setq lle (* 0.01 lle_pc bl_length))

	(setq lte_list (list lte))
	(setq lle_list (list lle))

	(setq length_te (append length_te lte_list))
	(setq length_le (append length_le lle_list))

	(setq val1 (+ lte_pc lle_pc))
	(setq val2 (* 0.01 val1 bl_length))
	(setq val3 (list val2))
	(setq lengths (append lengths val3))
	(setq i (1+ i))
)
(setq lengths (cdr lengths))
(setq length_le (cdr length_le))
(setq length_te (cdr length_te))


(command "line" (makecoord (nth 0 length_le) (* 0.2 r) ) (makecoord  (* -1 (nth 0 length_te)) (* 0.2 r) )    "")




;;;;;;;;;;;;;;;;;;;;;;;;;old code;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;now defunct;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;now replaced by faster, better code;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq offsetfile_1 (open "D:/bladelength.txt" "r"))
;(setq flag 1)
;(setq lengths (list nil))
;(while flag
;
;	(setq val1 (read-line offsetfile_1))
;	(setq val2 (* -0.01 (atof val1)))		;;;;;;;;;
;	(setq coordx (* val2 bl_length))		;;;;;;;;; These stupis codes are for
;	(setq val3 (list coordx))			;;;;;;;;; adding elements to the list
;	(setq lengths (append lengths val3))		;;;;;;;;;
;		(setq flag (1+ flag))
;	(if (>= flag 9)(setq flag nil))
;)
;(setq lengths (cdr lengths))
;(setq val1 (read-line offsetfile_1))

;(setq flag 7)

;(;while flag
;	(setq val1 (read-line offsetfile_1))
;	(setq val2 (* 0.01 (atof val1)))		
;	(setq coordx (* val2 bl_length))	
;	(setq len1 (nth flag lengths))
;	(setq totlen (+ len1 coordx))
;;	(setq lengths (subst totlen len1 lengths))
;	(setq flag (1- flag))
;	(if (<= flag -1)(setq flag nil))
;)

;(close offsetfile_1)






;;;;;;;DRAWING THICKNESS LINE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(setq offsetfile_1 (open "D:/bladelength.txt" "r"))
(setq offsetfile_2 (open "D:/thickness.txt" "r"))




(read-line offsetfile_2)

(repeat 8
(read-line offsetfile_1)
)


(setq lineyl r)
(Command "spline")
(setq val1 (read-line offsetfile_1))
(setq val2 (* 0.01 (atof val1)))
(setq projectedx (* val2 bl_length))
(Command (makecoord projectedx lineyl))
(setq toppoint (makecoord projectedx lineyl))

(setq flag 7)

(while flag

	(setq lineyl (- lineyl (* 0.1 r)))

	(setq val1 (read-line offsetfile_2))
	(setq val2 (* 0.01 (atof val1)))
	(setq dst_le (* val2 (nth flag lengths)))

	(setq val3 (read-line offsetfile_1))

	(setq val4 (* 0.01 (atof val3)))
	(setq projectedx (* val4 bl_length))

	(setq linexl (- projectedx dst_le))


	(Command (makecoord linexl lineyl))

 	(setq flag (1- flag))
	
  			(if (<= flag -1)(setq flag nil)) 

);



(Command "" "" "")
;;

(close offsetfile_2)

(close offsetfile_1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;TO OBTAIN MAX THICKNESS;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;POINT DISTANCES FROM LE;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq maxthkpnt_pc (read2array "d:/thickness.txt" 1 8))
(setq maxthkpnt_pc (reverse maxthkpnt_pc))
(setq maxthkpnt (list 0))


(setq i 0)

(while i

	(setq val1 (* 0.01 (nth i maxthkpnt_pc)))

	(setq maxthkpnt_s (* val1 (nth i lengths)))

	(setq val2 (list maxthkpnt_s))
	(setq maxthkpnt (append maxthkpnt val2))

	(setq i (1+ i))
	
 			(if (>= i 8)(setq i nil)) 

)

(setq maxthkpnt (cdr maxthkpnt))

(bladeface)
(bladesection)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;To obtain max thickness at each r;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun bladeface()

(setq maxthkpnt_pc (read2array "d:/thickness.txt" 1 8))
(setq maxthkpnt_pc (reverse maxthkpnt_pc))
(setq thk_pc (read2array "d:/thickness.txt" 10 9))
(setq thk (list 0))
(setq i 0)

(while i
	(setq val1 (* 0.01 (nth i thk_pc) d))
	(setq val2 (list val1))
	(setq thk (append thk val2))
	(setq i (1+ i))
	(if (>= i 9)(setq i nil))
)
(setq thk (cdr thk))
(princ thk)	


)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;TO DRAW BLADE SECTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-------<---------<----VIP loop in loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun bladesection ()

(setq j 0)
(setq off1 0)
(setq off2 0)
(setq off3 0)
(setq off4 0)
(setq yvalue (* 0.2 r))
(setq projection1 (list nil))
(setq val_a (list nil))
(setq val_b (list nil))
(setq vals (list nil))

(repeat 8



(setq faceht_te (read2array "d:/sections.txt" (+ off1 2) 5))
(setq faceht_le (read2array "d:/sections.txt" (+ off1 8) 7))


(setq te_thk_dst (- (nth j lengths) (nth j maxthkpnt)))


(setq tt_div (/ te_thk_dst 5))
(setq lt_div (/  (nth j maxthkpnt) 5))





(command "spline")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;down part of section

(setq i 0)

(while i

	(setq val1 (* (nth i faceht_te) (nth j thk) 0.01))
	(setq liney (+ yvalue val1))

	(setq val1 (* (nth j length_te) -1))
	(setq val2 (* i tt_div))
	(setq linex (+ val1 val2));


	(command (makecoord linex liney))
	(IF (= i 0) 
	(setq val_a (makecoord linex liney))
	)

	(setq i (1+ i))
	(if (>= i 5)(setq i nil))
)




(command (makecoord (- (nth j length_le) (nth j maxthkpnt)) yvalue))

(setq i 4)
(setq x 0)


(while i

	(setq ht1 (* (nth x faceht_le) (nth j thk) 0.01))

	(setq liney (+ yvalue ht1))

	(setq val1 (* i lt_div))


	(setq linex (- (nth j length_le) val1))


	(command (makecoord linex liney))

	(setq x (1+ x))




	(if (= i 0)(setq i nil))
	(if (= i 0.25)(setq i 0))
	(if (= i 0.5)(setq i 0.25))
	(if (= i 1)(setq i 0.5))
	(if (>= i 2)(setq i (1- i)))
	
)


(setq val_b (makecoord linex liney))

(setq vals (list val_a val_b))
(setq vals (list vals))
(setq projection1 (append projection1 vals))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;up part of section

(setq backht_te (read2array "d:/sections.txt" (+ off1 16) 4))
(setq backht_le (read2array "d:/sections.txt" (+ off1 21) 6))
(setq backht_te (reverse backht_te))
(setq backht_le (reverse backht_le))


(setq i 0.25)
(setq x 0)

(while i

	(setq ht1 (* (nth x backht_le) (nth j thk) 0.01))

	(setq liney (+ yvalue ht1))

	(setq val1 (* i lt_div))


	(setq linex (- (nth j length_le) val1))


	(command (makecoord linex liney))

	


	(setq x (1+ x))
	
	(if (>= i 1)(setq i (1+ i)))
	(if (= i 0.5)(setq i 1))
	(if (= i 0.25)(setq i 0.5))
	

	(if (>= i 5)(setq i nil))
)


(command (makecoord (- (nth j length_le) (nth j maxthkpnt)) (+ yvalue (nth j thk)) ))



(setq i 3)
(setq x 0)
(while i

	(setq val1 (* (nth x backht_te) (nth j thk) 0.01))
	(setq liney (+ yvalue val1))

	(setq val1 (* (nth j length_te) -1))
	(setq val2 (* (+ i 1) tt_div))
	(setq linex (+ val1 val2))

	(setq x (1+ x))
	(command (makecoord linex liney))
	(setq i (1- i))
	(if (<= i -1)(setq i nil))
)




(command "c" "")

(setq off1 (+ off1 27))


(setq yvalue (+ (* 0.1 r) yvalue))

(setq j (1+ j))
)

(setq projection1 (cdr projection1))

)

















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;TO DRAW PROJECTED OUTLINE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun draw_2 ()

	(command "Circle" center "d" (* 0.2 d))
	(command "Line" center (makecoord 0 r) "")
	(setq i 0)
	

	(while i
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
		(setq pnt1 (nth 0 (nth i projection1)))
		(setq pnt2 (makecoord 0 yvalue))
		(setq val1 (/ p (* 2 pi)))
		(setq phi (atan (/ yvalue val1)))
		(setq proj_pnt (proj_view pnt1 pnt2 phi 1))
		;(command proj_pnt)
		(command "arc" pnt2 "c" (makecoord 0 0) "A" angdeg)



	(setq i (1+ i))
	(if (>= i 8) (setq i nil))
	)
(setq i 8)
(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
(setq pnt2 (makecoord 0 yvalue))
	
;(command "arc" pnt2 "c" (makecoord 0 0) toppoint)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TO CORRECT HERE OR NEXT TO GET CORRECT POINT. FOR LATER

(setq i 7)

	(while i
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
		(setq pnt1 (nth 1 (nth i projection1)))
		(setq pnt2 (makecoord 0 yvalue))
		(setq val1 (/ p (* 2 pi)))
		(setq phi (atan (/ yvalue val1)))
		(setq proj_pnt (proj_view pnt1 pnt2 phi 1))
		;(command proj_pnt)
		(command "arc" pnt2 "c" (makecoord 0 0) "A" angdeg)



	(setq i (1- i))
	(if (<= i -1) (setq i nil))
	)






(command "spline")

(setq i 0)
	(while i
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
		(setq pnt1 (nth 0 (nth i projection1)))
		(setq pnt2 (makecoord 0 yvalue))
		(setq val1 (/ p (* 2 pi)))
		(setq phi (atan (/ yvalue val1)))
		(setq proj_pnt (proj_view pnt1 pnt2 phi 1))
		(command proj_pnt)
		;(command "line" (makecoord 0 0) proj_pnt "")



	(setq i (1+ i))
	(if (>= i 8) (setq i nil))
	)



(setq i 8)
(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
(setq pnt2 (makecoord 0 yvalue))
	
(command toppoint)

(setq i 7)

	(while i
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
		(setq pnt1 (nth 1 (nth i projection1)))
		(setq pnt2 (makecoord 0 yvalue))
		(setq val1 (/ p (* 2 pi)))
		(setq phi (atan (/ yvalue val1)))
		(setq proj_pnt (proj_view pnt1 pnt2 phi 1))
		(command proj_pnt)
		


	(setq i (1- i))
	(if (<= i -1) (setq i nil))
	)






(command "" "" "")




)



(Defun proj_view (pnt1 pnt2 ang1 const)

;;;;;;;;For getting the coordinates;;;;;

(setq y2 (gety pnt2))
(setq ang3 (- (/ pi 2) ang1))

(setq ang2 (- pi (angle pnt2 pnt1)))


(setq q (+ ang3 ang2))



(setq dist (distance pnt1 pnt2))

(setq proj (* dist (cos q)))
(setq angrad (/ proj y2))
(setq angdeg (* angrad (/ 180 pi)))
(setq angrad (+ angrad (/ pi 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;For finding polar coordinates;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq expx (* y2 (cos angrad) const))
(setq expy (* y2 (sin angrad)))

(makecoord expx expy)


)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;TO DRAW DEVELOPED VIEW;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(defun draw_3 ()

(setq expanded (read2array "D:/Bladelength.txt" 0 17))
(setq i 0)	
(setq expxlist (list 1.01 ))
(Repeat 17
	(setq lav1 (* 0.01 (nth i expanded)))
	(setq lav2 (* lav1 bl_length))
	(setq lav3 (list lav2))
	(setq expxlist (append expxlist lav3))
	(setq i (1+ i))
)	
(setq expxlist (cdr expxlist))


	(command "Circle" center "d" (* 0.2 d))
	(command "Line" center (makecoord 0 r) "")


(setq i 0)
(setq j 0)


(while i
		
		(setq dev_pnt (devlp_view -1))
		;(command dev_pnt)
		(setq pnt2 (makecoord 0 yvalue))
		(command "arc" pnt2 "c" dev_centre "A" angdeg)

	(setq j (1+ j))

	(setq i (1+ i))
	(if (>= i 8) (setq i nil))
	)


(setq i 7)
(setq j 9)



(while i
		
		(setq dev_pnt (devlp_view -1))
		;(command dev_pnt)
		(setq pnt2 (makecoord 0 yvalue))
		(command "arc" pnt2 "c" dev_centre "A" angdeg)

	
	(setq j (1+ j))
	(setq i (1- i))
	(if (<= i -1) (setq i nil))
)






(setq i 0)
(setq j 0)

(command "spline")

(while i
		
		(setq dev_pnt (devlp_view -1))
		(command dev_pnt)


	(setq j (1+ j))

	(setq i (1+ i))
	(if (>= i 8) (setq i nil))
	)


(setq i 7)
(setq j 9)


(command toppoint)



(while i
		
		(setq dev_pnt (devlp_view -1))
		(command dev_pnt)
		

	
	(setq j (1+ j))
	(setq i (1- i))
	(if (<= i -1) (setq i nil))
)



(command "" "" "")


)





(Defun devlp_view (const)									;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
												;;;;;;;;;;;;;THIS IS SUCH A LEAN MEAN;;;;;;;;
												;;;;;;;;;;;;;;;BEAUTIFUL FUNCTION;;;;;;;;;;;;
												;;;;;;;;;;I THINK I'M IN LOVE WITH IT;;;;;;;;
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(setq val1 (/ p (* 2 pi)))
		(setq phir (atan (/ yvalue val1)))
		(setq phi (- (/ pi 2) phir))
		(setq local_radius (/ yvalue (* (cos phi) (cos phi) )))
		(setq cent_y (- yvalue  local_radius))
		(setq dev_centre (makecoord 0 cent_y))



		(setq angrad (/ (nth j expxlist) local_radius))
		(setq angdeg (* angrad (/ 180 pi) const))
		(setq angrad (+ angrad (/ pi 2)))
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;For finding polar coordinates;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		(setq expx (* local_radius (cos angrad) const))
		(setq expy (* local_radius (sin angrad)))
		(setq expy (+ expy cent_y))
(makecoord expx expy)
)








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;TO DRAW SIDE ELEVATION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun draw_4 ()
;
(setq rakerad (* rake (/ pi 180)) )
(setq thk (reverse thk))





(setq x2 (* r -1 (/ (sin rakerad) (cos rakerad) ) ) )




(setq y2 r)


(setq toppoint2 (makecoord x2 y2))

(command "Line" (makecoord 0 0) toppoint2 "")
(setq prop_length (distance (makecoord 0 0) toppoint2))




(command "spline" )

(setq i 8)
(setq j 0)
(Repeat 9
	(setq y2 (+ (* 0.2 r) (* i 0.1 r)))
	(setq x2 (* y2 -1 (/ (sin rakerad) (cos rakerad) ) ) )

	
	(setq x2 (+ x2 (nth j thk)))
	(command (makecoord x2 y2))
	(setq i (1- i))
	(setq j (1+ j))

)

(command "" "" "")





;(command "spline")

(setq i 0)
	(while i
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
		(setq pnt1 (nth 0 (nth i projection1)))
		(setq pnt2 (makecoord 0 yvalue))
		(setq val1 (/ p (* 2 pi)))
		(setq phi (atan (/ yvalue val1)))
		(setq long_pnt (long_view pnt1 pnt2 phi 1))
		(command long_pnt)
		



	(setq i (1+ i))
	(if (>= i 8) (setq i nil))
	)



(setq i 8)
(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
(setq pnt2 (makecoord 0 yvalue))
	
(command toppoint2)

(setq i 7)

	(while i
		(setq yvalue (+ (* 0.2 r) (* i 0.1 r)))
		(setq pnt1 (nth 1 (nth i projection1)))
		(setq pnt2 (makecoord 0 yvalue))
		(setq val1 (/ p (* 2 pi)))
		(setq phi (atan (/ yvalue val1)))
		(setq long_pnt (proj_view pnt1 pnt2 phi -1))
(command long_pnt)
		


	(setq i (1- i))
	(if (<= i -1) (setq i nil))
	)






;(command "" "" "")




)





(Defun long_view (pnt1 pnt2 ang1 const)



(setq y2 (gety pnt2))
;(setq ang3 (- (/ pi 2) ang1))

(setq ang2 (- pi (angle pnt2 pnt1)))


(setq q (- ang1 ang2))



(setq dist (distance pnt1 pnt2))

(setq proj (* dist (cos q)))
(setq angrad (/ proj y2))
(setq angdeg (* angrad (/ 180 pi)))
(setq angrad (+ angrad (/ pi 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;For finding polar coordinates;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq expx (* y2 (cos angrad)))
(setq expy (* y2 (sin angrad)))

(setq x2 (* y2 const (/ (sin rakerad) (cos rakerad) ) ) )

(setq expx (- expx x2))


(makecoord expx expy)


)

























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; GENERAL FUNTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun read2array(filename repeatno1 repeatno2)

	(setq readfile (open filename "r"))
	(setq array (list 1.00))

	(repeat repeatno1
		(read-line readfile)
	)


	(repeat repeatno2
	
		(setq value (read-line readfile))
		(setq value (atof value))
		(setq value2 (list value))
		(setq array (append array value2))


	)
	(close readfile)

	(cdr array)
	

)











(defun initialise ()

;Save System Variables

	(setq oldsnap (getvar "osmode"))
	;save snap settings

	(setq oldblipmode (getvar "blipmode"))
	;save blipmode setting

;Switch OFF System Variables

	(setvar "osmode" 0)
	;Switch OFF snap

	(setvar "blipmode" 0)
	;Switch OFF Blipmode
)



(defun deinitialise ()
	;Reset System Variable

	(setvar "osmode" oldsnap)
	;Reset snap

	(setvar "blipmode" oldblipmode)
	;Reset blipmode
)


(defun error_handling ()
	(alert "WTF?! Dude! Error!")
	(deinitialise)
	(quit)
)


(defun getx (point)
 	 (car point)
)


(defun gety (point)
 	 (cadr point)
)



(defun makecoord (x y)
	(list x y 0)
)