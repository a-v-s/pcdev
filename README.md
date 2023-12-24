# BlaatSchaap Coding Projects pcdev

A GNU Makefile project for hosted development, a counterpart of ucdev, which is 
for microcontroller development.

* It supports gcc and clang compilers
* It supports native and cross compilation
* It runs on Linux and MSYS2, not tested on other *NIXes.

Examples

By default it compiles for  the  host
```
[andre@mortar hello_world_c++]$ make
GIT_BRANCH: master
GIT_COMMIT: 8c9972b-dirty
HOST:   linux
TARGET: linux
Compiling     hello.cpp...
Linking       out/gcc/linux/x86_64/debug/hello_c++...
```

It can cross compile for Microsoft® Windows™ setting the `TARGET_OS` to `mingw` .
It will target the hos machine by default. 
```
[andre@mortar hello_world_c++]$ make TARGET_OS=mingw
GIT_BRANCH: master
GIT_COMMIT: 8c9972b-dirty
HOST:   linux
TARGET: mingw
Compiling     hello.cpp...
Linking       out/gcc/mingw/x86_64/debug/hello_c++.exe...
```

It can generate 32-bit Windows by adding `i686` as a  `TARGET_MACHINE` 
```
[andre@mortar hello_world_c++]$ make TARGET_OS=mingw TARGET_MACHINE=i686
GIT_BRANCH: master
GIT_COMMIT: 8c9972b-dirty
HOST:   linux
TARGET: mingw
Compiling     hello.cpp...
Linking       out/gcc/mingw/i686/debug/hello_c++.exe...
```

It can use the clang compiler in stead of the default gcc by specifying `COMPILER=clang` 
```
[andre@mortar hello_world_c++]$ make COMPILER=clang
GIT_BRANCH: master
GIT_COMMIT: 8c9972b-dirty
HOST:   linux
TARGET: linux
Compiling     hello.cpp...
Linking       out/clang/linux/x86_64/debug/hello_c++...
```

Cross-compilation to ARM targets is not supported yet.
