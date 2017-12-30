#lang racket/gui
(require "constants.rkt")
(require "pad.rkt")
(require "brick.rkt")
(provide (all-defined-out))

;Här definierar vi bollens klass
(define ball% (class object%
                (init-field width
                            height
                            xpos
                            ypos
                            speed
                            angle
                            score)
                
;Följande procedurer ger ut samt ändrar på bollens värden
                (define/public (get-width) width)
                (define/public (set-width value)
                  (set! width value))
                
                (define/public (get-height) height)
                (define/public (set-height value)
                  (set! height value))
                
                (define/public (get-xpos) xpos)
                (define/public (set-xpos value)
                  (set! xpos value))
                
                (define/public (get-ypos) ypos)
                (define/public (set-ypos value)
                  (set! ypos value))
                
                (define/public (get-speed) speed)
                (define/public (set-speed value)
                  (set! speed value))
                
                (define/public (get-angle) angle)
                (define/public (set-angle value)
                  (set! angle value))
                
;Denna procedur utför bollens förflyttning
                (define/public (ball-mover)
                  (set! ypos (- ypos (* speed (sin angle))))
                  (set! xpos (+ xpos (* speed (cos angle)))))
                
;Denna procedur hanterar bollens kollision med väggar och plattan
                (define/public (collision-handler frame-width)
                  (let ((pad-xpos (send *pad* get-xpos))
                        (pad-ypos (send *pad* get-ypos))
                        (pad-width (send *pad* get-width))
                        (pad-height (send *pad* get-height)))
                    
                    (cond ((< xpos 0)
                           (set! angle (- pi angle))
                           (set! xpos 0))
                          ((< ypos 0)
                           (set! angle (- 0 angle))
                           (set! ypos 0))
                          ((> (+ xpos width) frame-width)
                           (set! angle (- pi angle))
                           (set! xpos (- frame-width width)))
                          ((and (and (>= (+ xpos width) pad-xpos)
                                     (<= xpos (+ pad-xpos pad-width)))
                                (and (> (+ ypos height) pad-ypos)
                                     (< (+ ypos height) (+ pad-ypos pad-height))))
                           (set! angle (+ (/ pi 12)
                                          (* (/ (- (+ pad-xpos pad-width)
                                                   (+ xpos (/ width 2))) (/ pad-width 10))
                                             (/ pi 12))))))))
                
;Denna procedur hanterar bollens kollision med brickor och lägger till poäng
;varje gång bollen kolliderar med en bricka. När bollen träffar en speciell
;bricka anropar den passande effekt-procedur
                (define/public (brick-collision bricks-hash)
                  (let ((ball-int-xpos (inexact->exact (round xpos)))
                        (ball-int-ypos (inexact->exact (round ypos))))
                    (let ((ball-coord (cons (- ball-int-xpos (modulo ball-int-xpos (send *bricks* get-width)))
                                            (- ball-int-ypos (modulo ball-int-ypos (send *bricks* get-height))))))
                      (when (hash-has-key? bricks-hash ball-coord)
                        (when (= (hash-ref bricks-hash ball-coord) 2)
                          (set! speed (* speed 1.5))
                          (send *speed-brick-timer* start 6000 #t))
                        (when (= (hash-ref bricks-hash ball-coord) 3)
                          (send *pad* pad-resizer-start)
                          (send *brick-resizer-timer* start 8000 #t))
                        (when (= (hash-ref bricks-hash ball-coord) 4)
                          (send *pad* pad-speed-start)
                          (send *pad-speed-timer* start 9001 #t))
                        (hash-remove! bricks-hash ball-coord)
                        (set! angle (- 0 angle))
                        (set! score (+ score 5))))))
                
;Denna procedur anropas av en timer som startar när bollen träffar en viss
;speciell bricka
                (define/public (speed-brick-effect)
                  (set! speed (/ speed 1.5)))
                
                (define/public (get-score)
                  score)
                
                (super-new)))

;Här skapar vi vår boll
(define *ball* (new ball% 
                    [width ball-width]
                    [height ball-height]
                    [xpos 622]
                    [ypos 400]
                    [speed ball-speed]
                    [angle (/ pi 2)]
                    [score 0]))

;Dessa timers anropas när bollen kolliderar med en viss speciell bricka och
;anropar en procedur och sedan stannar vid första tick
(define *speed-brick-timer* (new timer%
                                 [notify-callback (lambda () (send *ball* speed-brick-effect))]))

(define *brick-resizer-timer* (new timer%
                                 [notify-callback (lambda () (send *pad* pad-resizer-stop))]))

(define *pad-speed-timer* (new timer%
                                 [notify-callback (lambda () (send *pad* pad-speed-stop))]))