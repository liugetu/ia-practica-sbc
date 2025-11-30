#!/bin/bash
# Script per executar prova2.clp amb ontologia.clp

clips <<'EOF'
(load "ontologia.clp")
(load "prova2.clp")
(reset)
(run)
(exit)
EOF
