#!/bin/bash
# Test del menú interactiu amb entrades simulades

echo "=== Test 1: Mostrar totes les recomanacions ==="
echo "1
3" | clips -f run_query_all2.clp

echo ""
echo ""
echo "=== Test 2: Consultar client específic ==="
echo "2
client-parella-centre
3" | clips -f run_query_all2.clp

echo ""
echo ""
echo "=== Test 3: Client que no existeix ==="
echo "2
ClientNoExistent
3" | clips -f run_query_all2.clp
