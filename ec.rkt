#lang racket

(require plot/pict)
(require racket/gui)

; Create the frame
(define frame (new frame% [label "Elliptic Curves"]))

; Create a picture
(define graph
  (plot (function sin (- pi) pi #:label "y = sin(x)")))

; Display GUI
(send frame show #t)
