#lang racket/base

; Pity: Pi-Calculus Inference
; Copyright (C) 2010  Andrea Bolognani <andrea.bolognani@roundhousecode.com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

(require racket/set
         racket/function
         pity)

(define (environments-count p s)
  (let* ([proc (string->process p)]
         [srt (string->sorting s)]
         [envs (process-environments proc srt)]
         [ones (set-map envs (lambda (e) 1))])
    (apply + ones)))

(define (stopwatch-execution p s n)
  (let* ([start-time (current-milliseconds)]
         [proc (string->process p)]
         [srt (string->sorting s)]
         [envs (process-respects? proc srt)]
         [end-time (current-milliseconds)])
    (- end-time start-time)))

(let* ([p "(a)(a<b,c>.0|a(e,f).e<g,h>.f<i>.0)|b(j,k).0|!c(l).0"]
       [s "s=(s,t);t=(p);p=(p);n=(n,m);m=(t)"]
       [iterations 100]
       [avg (build-list iterations (curry stopwatch-execution p s))]
       [avg (floor (/ (apply + avg) iterations))]
       [envs (environments-count p s)])
  (printf "Process:      ~a~n" p)
  (printf "Sorting:      ~a~n" s)
  (printf "Environments: ~a~n" envs)
  (printf "Iterations:   ~a~n" iterations)
  (printf "Average time: ~ams~n" avg))
