#!/bin/sh

sbcl <<EOF
  (asdf:initialize-source-registry "")
  (ql:quickload 'cta)
  (in-package :cta.controller)
  (sb-ext:save-lisp-and-die "chicago-transit" :executable t)
EOF
