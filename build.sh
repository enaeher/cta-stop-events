#!/bin/sh

sbcl <<EOF
  (unless (find-package 'quicklisp)
    (error "building chicato-transit requires quicklisp"))
  (asdf:initialize-source-registry "")
  (ql:quickload 'cta)
  (save-lisp-and-die "chicago-transit" :executable t)
EOF
