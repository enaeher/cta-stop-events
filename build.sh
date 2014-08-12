#!/bin/sh

sbcl --disable-debugger <<EOF
  (asdf:initialize-source-registry "")
  (ql:quickload 'cta)
  (sb-ext:save-lisp-and-die "chicago-transit" :executable t)
EOF
