#lang racket
;Window properties
(define window-width 1280)
(define window-height 720)

(provide window-width)
(provide window-height)

;Pad properties
(define pad-width (/ window-width 6.4))
(define pad-height (/ window-height 24))
(define pad-speed 5)

(provide pad-width)
(provide pad-height)
(provide pad-speed)

;Brick properties
(define brick-width (/ window-width 20))
(define brick-height (/ window-height 30))

(provide brick-width)
(provide brick-height)

;Brick effect properties
(define speed-effect 2)

(provide speed-effect)

;Ball properties
(define ball-width (/ window-width 80))
(define ball-height (/ window-height 45))
(define ball-speed 5)

(provide ball-width)
(provide ball-height)
(provide ball-speed)