(ql:quickload "cl-who")
(ql:quickload "hunchentoot")
(ql:quickload "parenscript")
(ql:quickload "elephant")

(in-package :cl-user)

(defpackage :tianguis
  (:use :cl :cl-who :hunchentoot :parenscript :elephant))

(in-package :tianguis)

;; Start our web server.
; (setf *web-server* (start-server :port 8080))
(setf *web-server*
      (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4243)))
; 

(setq *dispatch-table*
 (list
  (create-regex-dispatcher "^/" 'oferta)
  (create-regex-dispatcher "^/publicar/oferta" 'vote)))


;; Publish all static content.
(push (create-static-file-dispatcher-and-handler "/logo.jpg" "imgs/logo.jpg") *dispatch-table*)
(push (create-static-file-dispatcher-and-handler "/semantic/dist/semantic.min.css" "semantic/dist/semantic.min.css") *dispatch-table*)
(push (create-static-file-dispatcher-and-handler "/semantic/dist/semantic.min.js" "semantic/dist/semantic.min.js") *dispatch-table*)


;; Launch Elephant
;; (elephant:open-store '(:BDB "/tmp/game.db"))
(elephant:open-store '(:CLSQL (:SQLITE3 "/tmp/tianguis.sqlite")))



(defpclass persistent-merchandise ()
  ((name :reader name :initarg :name :index t)
   (description :accessor description)
   (measure :accessor measure)))

(defmethod str ((merchandise persistent-merchandise))
            (format t "merchandise: ~s of ~s"
                    (measure merchandise)
                    (name merchandise)))

(defpclass persistent-advertisement ()
  ((title :reader title :initarg :name :index t)
   (date-time :reader date-time)
   (place :reader place)
   (description :reader description)
   (author :reader author)))

(defpclass persistent-merchandise-in-ad ()
  ((merchandise :reader merchandise)
   (quantity :reader quantity)
   (price :reader price)
   (sale :reader sale)))




;; All pages on the Retro Games site will use the following macro; less to type and 
;; a uniform look of the pages (defines the header and the stylesheet).
(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml"  :xml\:lang "en" :lang "en"
       (:head 
         (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8")
	 (:title ,title)
	 (:link :type "text/css" :rel "stylesheet" :href "/semantic/dist/semantic.min.css")
	 (:script :src "/semantic/dist/semantic.min.js"))
       (:body
	(:br)
	(:div :class "ui container" 
	      (:h2 :class "ui center dividing header" ,title)
	      (:div :class "ui container"
		    ,@body))))))

;;
;; The functions responsible for generating the HTML go here.
;;

(defun oferta ()
  (standard-page (:title "Tianguis")
    (:p "La Granja ofrece, en su centro de distribución")
    (:table :class "ui right aligned table"
	    (:thead
	     (:tr
	      (:th :class "left aligned" "producto")
	      (:th "cantidad")
	      (:th "precio")))
	    (:tbody
	     (:tr
	      (:td "acelga hidropónica")
	      (:td "2")
	      (:td "300"))))))




