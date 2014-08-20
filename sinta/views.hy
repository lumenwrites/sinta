; vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 filetype=lisp

(import [django.shortcuts [render-to-response]])
(import [django.shortcuts [render-to-response]])
(import [django.views.decorators.csrf [csrf_exempt]])
(import [django.template [RequestContext]])

(import [sinta.core [testfun]])

(import [os]
        [sys]
        [json]
		[io]        
        [hy.cmdline [HyREPL]])


(defclass MyHyREPL [HyREPL]
  [[eval (fn [self code]
           (setv old-stdout sys.stdout)
           (setv old-stderr sys.stderr)
           (setv fake-stdout (io.StringIO))
           (setv sys.stdout fake-stdout)
           (setv fake-stderr (io.StringIO))
           (setv sys.stderr fake-stderr)
           (HyREPL.runsource self code "<input>" "single")
           (setv sys.stdout old-stdout)
           (setv sys.stderr old-stderr)
           {"stdout" (fake-stdout.getvalue) "stderr" (fake-stderr.getvalue)})]])


(defn home [request]
	(if (not (request.POST.get "in"))
		(setv input "Your commands")
		(setv input (request.POST.get "in")))
	(setv action (get (.split input) 0))
	(setv subject (get (.split input) 1))

	(setv output "Welcome to Sinta! Try going north")

	(if (= action "go")
		(if (= subject "north")
			(setv output "Im in the  <span class='orange'> yard </span>. barbed wire fence separates it from the street. <br /> There's a ladder lying on the ground")
			(setv output "Im in the <span class='orange'> warehouse</span>. What a shithole. <br /> My backpack lies in the corner where Ive slept.")))
	; (let [[repl (MyHyREPL)] [input (request.POST.get "in")]]
      ; (for [expr (get input "env")]
        ; (repl.eval expr))
		; (setv output (repl.eval (get input "code"))))
	; (setv output (eval (io.StringIO)))
	(render-to-response "index.html" {"input" input 
									  "output" output 
									  "action" action
									  "subject" subject} (RequestContext request)))