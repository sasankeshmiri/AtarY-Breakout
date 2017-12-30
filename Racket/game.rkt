#lang racket/gui
(require "properties.rkt")
(require "brick.rkt")
(require "ball.rkt")
(require "pad.rkt")
(require "graphics.rkt")
(require "canvas.rkt")
(provide (all-defined-out))

;Här definierar vi vår frame som också styr spelet
(define game%
  (class frame%
    (init-field width
                height)
    
    ;Denna procedur startar vår grafiktimer
    (define/public (start-graphics)
      (send *graphics-timer* start 16 #f))

    ;Denna procedur anropar alla grafikprocedurer i vår grafikklass
    (define/public (canvas-graphics canvas dc)
      (let ((bricks-hash (hash->list (send *bricks* get-hash))))
        (send *graphics* brick-graphics
              (hash->list (send *bricks* get-hash))
              dc
              (send *bricks* get-width)
              (send *bricks* get-height))
        (send *graphics* ball-graphics
              dc
              (send *ball* get-xpos)
              (send *ball* get-ypos)
              (send *ball* get-width)
              (send *ball* get-height))
        (send *graphics* pad-graphics
              dc
              (send *pad* get-xpos)
              (send *pad* get-ypos)
              (send *pad* get-width)
              (send *pad* get-height))
        (send *graphics* game-end-graphics
              bricks-hash
              width
              height
              (send *ball* get-height)
              dc)
        (send *graphics* score-graphics width (send *ball* get-score) dc)))

    ;Denna procedur anropas av grafiktimern och ser till att all grafik uppdateras
    (define/public (refresh-graphics)
      (send *our-canvas* refresh))
    
    ;Dessa två procedurer startar samt stannar fysiktimern
    (define/public (start-physics)
      (send *physics-timer* start 8 #f))
    (define/public (stop-physics)
      (send *physics-timer* stop))
    
    ;Denna procedur anropas av fysiktimern och anropar alla fysikprocedurer
    (define/public (physics)
      (let ((bricks-hash (send *bricks* get-hash)))
        (game-end (hash->list bricks-hash))
        (send *pad* pad-mover width)
        (send *ball* ball-mover)
        (send *ball* collision-handler width)
        (send *ball* brick-collision bricks-hash)))
    
    ;Denna procedur kollar om vår vinst- eller förlustkrav stämmer och ifall någon
    ;av dem gör det så stannar proceduren vår fysiktimer
    (define/public (game-end bricks-hash)
      (cond ((null? bricks-hash)
             (stop-physics))
            ((>= (send *ball* get-ypos) height)
             (stop-physics))))
    
    (super-new)))

;Här skapar vi vår frame som även styr spelet
(define *game* (new game%
                    [width window-width]
                    [height window-height]
                    [min-width window-width]
                    [min-height window-height]
                    [label "AtarY Breakout"]
                    [stretchable-width #f]
                    [stretchable-height #f]))

;Här skapar vi vår canvas där vi ritar all vår grafik
(define *our-canvas* (new input-canvas%
                          [parent *game*]
                          [paint-callback
                           (lambda (canvas dc)
                             (send *game* canvas-graphics canvas dc))]))

;Detta anropar en procedur som fyller i vår hashtabell som skapar våra bricks
(send *bricks* bricks-inserter 0 0)

;Denna timer anropar vår fysikprocedur i *game* vid varje tick
(define *physics-timer* (new timer%
                             [notify-callback
                              (lambda () (send *game* physics))]))

;Samma som timern ovan fast anropar proceduren som uppdaterar grafiken
(define *graphics-timer* (new timer%
                              [notify-callback
                               (lambda () (send *game* refresh-graphics))]))
