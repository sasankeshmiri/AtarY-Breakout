#lang racket
(require "game.rkt")

;Denna fil startar grafik- och fysiktimern samt öppnar spelrutan

(send *game* start-graphics)

(send *game* start-physics)

(send *game* show #t)