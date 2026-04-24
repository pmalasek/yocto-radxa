SUMMARY = "bitbake-layers recipe"
DESCRIPTION = "Recipe created by bitbake-layers"
LICENSE = "MIT"

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*            __  ____  _       _              *");
    bb.plain("* __  ___ __/ / |  _ \\| |_   _| |_ ___        *");
    bb.plain("* \\/ / '_  /  | |_) | | | | | | __/ _ \\       *");
    bb.plain("*  >  <| | | |  |  __/| | |_| | || (_) |  9    *");
    bb.plain("* /_/\\_\\_| |_|  |_|   |_|\\__,_|\\__\\___/      *");
    bb.plain("*                   xPluto9                   *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build
