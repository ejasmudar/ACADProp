(defun margin ()

(setq headingx (* -3 d))
(setq headingy (* 0.75 d))
(setq headpnt (makecoord headingx headingy))
(setq txtht (* 0.15 d))

(command "text" headpnt txtht "" "4 BLADED TROOST B PROPELLER")


(setq kiss (* -4 d))
(setq kiss2 (* 1 d))

(setq kiss3 (* 1 d))
(setq kiss4 (* -1 d))



(setq pnt1 (makecoord kiss kiss2));;;;;;;assigns value to pnt1;;;;;
(setq pnt2 (makecoord kiss3 kiss4));;;;;;;assigns value to pnt2;;;;;

(command "rectang" pnt1 pnt2);;;;draws a rectangle;;;;;

(setq dim1 (* 1 d))
(setq dim2 (* 0.5 d))


(setq pnt3 (makecoord (- dim1 kiss3) (+ dim2 kiss4)))
(command "rectang" pnt2 pnt3);;;we get a smaller rectangle;;;;;

(setq pnt13 (makecoord (- dim1 kiss3) kiss4)) 

;;;;;drawing the lines;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq l (* 0.4 d))

(setq l1 (* 0.3 d))

(setq l2 (* 0.2 d))

(setq l3 (* 0.1 d))


(setq pnt5 (makecoord kiss3 (+ l kiss4)))
(setq pnt6 (makecoord (- dim1 kiss3) (+ l kiss4)))

(command "line" pnt5 pnt6 "") 

(setq pnt7 (makecoord kiss3 (+ l1 kiss4)))
(setq pnt8 (makecoord (- dim1 kiss3) (+ l1 kiss4)))


(command "line" pnt7 pnt8 "")

(setq pnt9 (makecoord kiss3 (+ l2 kiss4)))
(setq pnt10 (makecoord (- dim1 kiss3) (+ l2 kiss4)))


(command "line" pnt9 pnt10 "")


(setq pnt11 (makecoord kiss3 (+ l3 kiss4)))
(setq pnt12 (makecoord (- dim1 kiss3) (+ l3 kiss4)))


(command "line" pnt11 pnt12 "")


;;;;;;;Writing Text;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq x1 ( * 0.25 d -1))
(setq y1 ( * 0.2 d -1))
(setq tht (* 0.04 d))
(command "text" (makecoord x1 y1) tht "" "EXPANDED VIEW")

(setq x1 (- x1 d))
(setq y2 ( * 0.15 d -1))

(command "text" (makecoord x1 y1) tht "" "PROJECTED VIEW")

(setq x1 (- x1 d))
(setq y2 ( * 0.15 d -1))

(command "text" (makecoord x1 y1) tht "" "DEVELOPED VIEW")

(setq x1 (- x1 d))
(setq y2 ( * 0.15 d -1))

(command "text" (makecoord x1 y1) tht "" "SIDE ELEVATION")


;;;;;;;text inside box;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq txtht (* 0.025 d))
(setq gap (* 0.03 d))

(setq xval (+ GAP (getx pnt6)))
(setq yval (+ gap (gety pnt6)))

(setq pnt (makecoord xval yval))


(command "text" pnt txtht "" "DEPARTMENT OF SHIP TECHNOLOGY")
(setq yval (+ (* 0.1 d -1) (gety pnt)))
(setq pnt (makecoord xval yval))

(command "text"  pnt txtht "" "AUTOMATED PROPELLER DRAWING")
(setq yval (+ (* 0.1 d -1) (gety pnt)))
(setq pnt (makecoord xval yval))

(command "text" pnt txtht "" "NAME: EJAS M, SHASHANK RV, DANIO J");;;;;;;;;;Here the student's name will come;;;;;;
(setq yval (+ (* 0.1 d -1) (gety pnt)))
(setq pnt (makecoord xval yval))


(command "text" pnt txtht "" "CHKD BY:");;;;;;;;Here the Guide's name will come;;;;;;
(setq yval (+ (* 0.1 d -1) (gety pnt)))
(setq pnt (makecoord xval yval))

(setq date (today))
(command "text" pnt txtht "" "SCALE: 1:1                                          DATE:")

(setq xval (+ xval (* 0.75 d)))
(setq pnt (makecoord xval yval))
(command "text" pnt txtht "" DATE)

)


(defun TODAY ( / d yr mo day)
;define the function and declare all variabled local

     (setq d (rtos (getvar "CDATE") 2 6)
     ;get the date and time and convert to text

          yr (substr d 3 2)
	  ;extract the year

          mo (substr d 5 2)
	  ;extract the month

         day (substr d 7 2)
	 ;extract the day

     );setq

     (strcat day "/" mo "/20" yr)
     ;string 'em together



);
