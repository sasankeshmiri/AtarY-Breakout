#lang racket
(require "properties.rkt")
(provide (all-defined-out))

;Här definierar vi plattans klass
(define pad% (class object%
               (init-field width
                           height
                           xpos
                           ypos
                           speed
                           pressed-key)
               
               ;Följande procedur ger ut samt ändrar på plattans olika egenskaper
               (define/public (get-width)
                 width)
               (define/public (set-width value)
                 (set! width value))
               
               (define/public (get-height)
                 height)
               (define/public (set-height value)
                 (set! height value))
               
               (define/public (get-xpos)
                 xpos)
               (define/public (set-xpos value)
                 (set! xpos value))
               
               (define/public (get-ypos)
                 ypos)
               (define/public (set-ypos value)
                 (set! ypos value))
               
               (define/public (get-speed)
                 speed)
               (define/public (set-speed value)
                 (set! speed value))
               
               ;Dessa procedurer förflyttar plattan höger och vänster
               (define/public (move-right)
                 (set! xpos (+ xpos speed)))
               (define/public (move-left)
                 (set! xpos (- xpos speed)))
               
               ;Denna procedur tar emot en knapptryckning när det sker på canvasen och berättar
               ;om vilken knapp som blivit nertryckt
               (define/public (key-code-checker key-code)
                 (cond ((eq? 'released key-code)
                        (set! pressed-key 'none))
                       ((eq? 'right key-code)
                        (set! pressed-key 'right))
                       ((eq? 'left key-code)
                        (set! pressed-key 'left))))

               ;Denna procedur kollar vilken knapp som blivit nertryckt (enligt proceduren
               ;ovan) och anropar passande förflyttningsprocedur definierad ovan
               (define/public (pad-mover frame-width)
                 (cond ((eq? pressed-key 'right)
                        (unless (>= (+ xpos width) frame-width)
                          (send *pad* move-right)))
                       ((eq? pressed-key 'left)
                        (unless (<= xpos 0)
                          (send *pad* move-left)))))
               
               ;Denna procedur anropas när bollen kolliderar med en speciell bricka kopplad
               ;till effekten
               (define/public (pad-resizer-start)
                 (set! width (/ width 2)))
               
               ;Detta avslutar den effekt påbörjad av proceduren ovan. Denna procedur anropas
               ;av en timer som sätts igång samtidigt som proceduren ovan anropas
               (define/public (pad-resizer-stop)
                 (set! width (* width 2)))
               
               ;Samma som de två procedurerna ovan men med olik effekt
               (define/public (pad-speed-start)
                 (set! speed (* speed speed-effect)))
               
               (define/public (pad-speed-stop)
                 (set! speed (/ speed speed-effect)))
               
               (super-new)))

;Här skapar vi spelarens platta
(define *pad* (new pad%
                 [width pad-width]
                 [height pad-height]
                 [xpos (- (/ window-width 2) (/ pad-width 2))]
                 [ypos (- window-height (* pad-height 2))]
                 [speed pad-speed]
                 [pressed-key 'none]))