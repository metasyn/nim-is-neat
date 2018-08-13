---
title: Nim is Neat
theme: moon

---
# nim

a whirlwind tour of the programming language (0.18)

xander johnson 2018

@metasyn

---

## contents

* overview
* motivation
* history
* features
* comparisons
* demo

---

## features

* efficient, expressive, elegant
* clean intuitive syntax 
* high performance, compiled
* statically & strongly typed
* depedency free binaries
* cross platform

---

## motivation

* C++ speed
* scala-esque flexibility
* pythonic ergonomics 
* GC'd a la golang
* "safe by default" like rust

---

## history

* 2005, MIT 2008 - Andreas Rumpf 
* ~370 contributors, 5.2k stars 
* Influences (in order of impact):
    * Modula 3, Delphi, Ada, C++, Python, Lisp, Oberon.
* Version 0.18
    * Prepping for 1.0 release

---

# features

---

* off-side (python)
* generics (C++)
* concepts (haskell's type class)
* metaprogramming (lisp)
* overloading (C)
* excellent C/C++ FFI

---

## (cross) compile

* C
* C++
* Objective-C
* Javascript 
* WASM (via emcscripten)

---

## syntax

```nim
import strformat
type
  Person = object
    name*: string # Field is exported using `*`.
    age: Natural  # Natural type ensures the age is positive.

var people = [
  Person(name: "John", age: 45),
  Person(name: "Kate", age: 30)
]

for person in people:
  # Type-safe string interpolation.
  echo(fmt"{person.name} is {person.age} years old")
```

---

## controversial

* case & style insensitivities
```nim
person.say_hello()
person.sayHello()
```

* uniform function call syntax (UFCS)
    * Rust, D
```nim
bark(dog)
dog.bark()
```

---

```nim
import sequtils

type Point = tuple[x, y: float]

proc `+`(p, q: Point): Point = (p.x + q.x, p.y + q.y)

proc `/`(p: Point, k: float): Point = (p.x / k, p.y / k)

proc average(points: seq[Point]): Point =
  foldl(points, a + b) / float(points.len)
```
* inlined at compile head 
* zero overhead vs imperative loop

---

## ffi

```nim
proc printf(formatstr: cstring)
  {.header: "<stdio.h>", varargs.}
printf("%s %d\n", "foo", 5)
```

---

## memory management

* garbage collection by default
* (soft) realtime support
* manual options

----

* default
    * Deferred Reference Counting
    * Stack references aren't counted
    * Cycle detection via mark & sweep over full thread-local heap

* soft
    * max pause & step length

* manual
    * manual reference marking
    * (de)alloc, (de)allocShared, (de)allocCStringArray

---

## Flexible

```nim
import sequtils, future, strutils
let list = @["Zidong Yang", "Toufic Boubez"]

# Functional
list.map(
 (x: string) -> (string, string) => (x.split[0], x.split[1])
).echo


# Procedural
for name in list:
  echo((name.split[0], name.split[1]))
```

----

## templates

```nim
template times(x: expr, y: stmt): stmt =
  for i in 1..x:
    y

10.times:
  echo "Hello World"
```

----

## OOP

```nim
type Animal = ref object of RootObj
  name: string
  age: int
method vocalize(this: Animal): string {.base.} = "..."
method ageHumanYrs(this: Animal): int {.base.} = this.age

type Dog = ref object of Animal
method vocalize(this: Dog): string = "woof"
method ageHumanYrs(this: Dog): int = this.age * 7

type Cat = ref object of Animal
method vocalize(this: Cat): string = "meow"
```

---

## dependency free binaries

![](https://nim-lang.org/assets/img/features/binary_size.png)

---

# speed

---

## python

```python
BIG_NUMBER = 2 ** 24

def func_python(N):
    d = 0.0
    for i in range(N):
        d += (i % 3 - 1) * i
    return d
```
* 3.08 s

----

## cython (2.5x)

```python
def func_cython(N):
    cdef float d = 0.0 # only change
    for i in range(N):
        d += (i % 3 - 1) * i
    return d
```
* 1.25 s

----

## Nim (as Python Package)

```bash
nimble install nimpy
```

```nim
import nimpy
from math import `mod`

proc func_nim*(N: int): float {.exportpy.} =
  for i in 0..N:
    result += float((i mod 3 - 1) * i)
```

```bash
nim c -d:release --app:lib --out:loop.so loop.nim
```

----

## Nim-Python (5x)

```python
from loop import func_nim
func_nim(BIG_NUMBER)
```
* 608 ms

----

## Nim Standalone (94x)

```nim
import loop
from math import pow

const BIG_NUMBER = int(pow(2.0, 24.0))
echo func_nim(BIG_NUMBER)
```

```bash
nim c -d:release test.nim
time ./test
```

* 32 ms

----

## Fortran (as Python Package) (115x)

* fortran magic + f2py

```fortran
subroutine func_fort(n, d)
      integer, intent(in) :: n
      double precision, intent(out) :: d
      integer :: i
      d = 0
      do i = 0, n - 1
        d = d + (mod(i, 3) - 1) * i
      end do
end subroutine func_fort
```

```python
# python
func_fort(BIG_NUMBER)
```
* 26.7 ms

---

# demo

---

## missing

* corporate sponsor
* missing libraries
* no REPL / sorta

---

# fin
