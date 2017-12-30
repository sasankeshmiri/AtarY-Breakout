#lang racket/gui
(require "pad.rkt")
(provide (all-defined-out))

;Här definierar vi vår canvas
(define input-canvas%
  (class canvas%
    
;Denna procedur körs när en knapptryckning sker och anropar plattans
;rörfunktioner när rätt knapp trycks ner
    (define/override (on-char key-event)
      (let ((key-code (send key-event get-key-code))
            (key-release-code (send key-event get-key-release-code)))
        (cond ((eq? 'right key-code)
               (send *pad* key-code-checker key-code))
              ((eq? 'left key-code)
               (send *pad* key-code-checker key-code))
              ((or (eq? 'right key-release-code)
                   (eq? 'left key-release-code))
               (send *pad* key-code-checker 'released)))))
    
    (super-new)))