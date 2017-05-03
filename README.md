# {{ project }}

## Usage

This repository contains a template for a nim project using the
[shake](http://shakebuild.com/) build system. It can be instantiated with
[pi](https://github.com/vmchale/project-init).

## Configuration

Any dependencies should be added to the `config/build.config` as a
comma-separated list, e.g.

```cfg
SRC_DIR = src
LIB_DEPENDS = [nimx, nim-pymod]
```

Run `./shake.hs configure` to install any dependencies.
