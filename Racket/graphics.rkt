#lang racket/gui
(provide (all-defined-out))

;Här definierar vi vår grafikklass som innehåller alla våra grafikprocedurer
(define graphics%
  (class object%
    
    ;Denna procedur ritar spelarens platta
    (define/public (pad-graphics dc xpos ypos width height)
      (let ((pad-color (make-object color% 0 255 0)))
        (send dc set-brush pad-color 'solid)
        (send dc draw-rectangle
              xpos
              ypos
              width
              height)))
    
    ;Denna procedur ritar bollen
    (define/public (ball-graphics dc xpos ypos width height)
      (let ((ball-color (make-object color% 0 0 0))
            (pen-color (make-object color% 255 255 255)))
        (send dc set-brush ball-color 'solid)
        (send dc set-pen pen-color 1 'transparent)
        (send dc draw-ellipse
              xpos
              ypos
              width
              height)))
    
    ;Denna procedur ritar ut brickorna genom att läsa hashtabellen som skapar
    ;brickorna. Olika typer av brickor ritas i olika färger
    (define/public (brick-graphics bricks-hash dc width height)
      (let ((brick-color (make-object color% 255 130 0))
            (speed-brick-color (make-object color% 0 200 255))
            (pad-resizer-brick-color (make-object color% 0 255 0))
            (pad-speed-brick-color (make-object color% 255 0 0))
            (pen-color (make-object color% 255 255 255)))
        (send dc set-pen pen-color 3 'solid)
        (unless (null? bricks-hash)
          (cond ((eq? (cdar bricks-hash) 1)
                 (send dc set-brush brick-color 'solid)
                 (send dc draw-rectangle
                       (caaar bricks-hash)
                       (cdaar bricks-hash)
                       width
                       height))
                ((eq? (cdar bricks-hash) 2)
                 (send dc set-brush speed-brick-color 'solid)
                 (send dc draw-rectangle
                       (caaar bricks-hash)
                       (cdaar bricks-hash)
                       width
                       height))
                ((eq? (cdar bricks-hash) 3)
                 (send dc set-brush pad-resizer-brick-color 'solid)
                 (send dc draw-rectangle
                       (caaar bricks-hash)
                       (cdaar bricks-hash)
                       width
                       height))
                ((eq? (cdar bricks-hash) 4)
                 (send dc set-brush pad-speed-brick-color 'solid)
                 (send dc draw-rectangle
                       (caaar bricks-hash)
                       (cdaar bricks-hash)
                       width
                       height)))
          (brick-graphics (cdr bricks-hash) dc width height))))
    
    ;Denna procedur skriver ut text på canvasen när spelet har vunnits/förlorats
    (define/public (game-end-graphics bricks-hash game-width game-height ball-height dc)
      (cond ((null? bricks-hash)
             (send dc draw-text
                   "Congratulations! You Won!"
                   (- (/ game-width 2) 100)
                   (/ game-height 2)))
            ((>= ball-height game-height)
             (send dc draw-text
                   "Game Over!"
                   (- (/ game-width 2) 60)
                   (/ game-height 2)))))
    
    ;Denna procedur ritar ut spelarens poäng på canvasen
    (define/public (score-graphics game-width score dc)
      (send dc draw-text
            (string-append "score: " (number->string score))
            (/ game-width 2)
            0))
            
    (super-new)))

;Här skapar vi vår grafikklass
(define *graphics*
  (new graphics%))






