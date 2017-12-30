#lang racket
(require "properties.rkt")
(provide (all-defined-out))

;Här definierar vi vår brickklass
(define bricks% (class object%
                  (init-field width
                              height
                              bricks-hash)
                  
                  ;Följande procedurer returnerar brickornas egenskaper
                  (define/public (get-width) width)
                  
                  (define/public (get-height) height)

                  (define/public (get-hash) bricks-hash)

                  ;Denna procedur stoppar in alla brickor i vår tomma hashtabell som sedan används för fysiken och grafiken
                  (define/public (bricks-inserter r k)
                    (cond ((and (= r 3)
                                (= k 17))
                           (hash-set! bricks-hash (cons (* width 18) (* height 4)) 1))
                          ((= k 17)
                           (hash-set! bricks-hash (cons (* width 18) (+ height (* r height))) 1)
                           (set! k 0)
                           (set! r (+ r 1))
                           (bricks-inserter r k))
                          (else (hash-set! bricks-hash (cons (+ width (* k width))
                                                             (+ height (* r height)))
                                           1)
                                (set! k (+ k 1))
                                (bricks-inserter r k)))
                    (hash-set! bricks-hash (cons (+ width (* 2 width))
                                                 (+ height (* 2 height)))
                               2)
                    (hash-set! bricks-hash (cons (+ width (* 15 width))
                                                 (+ height (* 2 height)))
                               3)
                    (hash-set! bricks-hash (cons (+ width (* 12 width))
                                                 (+ height (* 1 height)))
                               4)
                    (hash-set! bricks-hash (cons width
                                                 height)
                               4)
                    (hash-set! bricks-hash (cons (+ width (* 4 width))
                                                 (+ height (* 1 height)))
                               3)
                    (hash-set! bricks-hash (cons (+ width (* 17 width))
                                                 (+ height (* 3 height)))
                               2))
                  
                  (super-new)))

;Här skapar vi vår brickklass med storlek och hashtabell
(define *bricks*
  (new bricks%
       [width (/ window-width 20)]
       [height (/ window-height 30)]
       [bricks-hash (make-hash)]))