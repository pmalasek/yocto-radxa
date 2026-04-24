# 1. Vypneme kompilaci testu (pro setreni RAM)
EXTRA_OECMAKE += "-DJSON_BuildTests=OFF"

# 2. Zakazeme ptest, aby se Yocto nesnazilo instalovat neexistujici testovaci soubory
PTEST_ENABLED = "0"

