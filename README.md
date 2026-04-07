> [!NOTE]
> This repository is a fork of the [original, probably discontinued project](https://github.com/GuilhermeBrazilianSamurai/Wyvern) by [H3xad3cimal](https://github.com/GuilhermeBrazilianSamurai).
> All credit for his hard work belongs to him and only him!
> I am responsible only for making this README and some other minor things!!!

# Wyvern

A [compiled](https://en.wikipedia.org/wiki/Compiled_language), [statically](https://en.wikipedia.org/wiki/Type_system#Static_type_checking) and [strong](https://en.wikipedia.org/wiki/Type_safety) typed, [inferred](https://en.wikipedia.org/wiki/Type_inference), [object-oriented](https://en.wikipedia.org/wiki/Object-oriented_programming) programming language written in [MiniScript](https://miniscript.org/) by [H3xad3cimal](https://github.com/GuilhermeBrazilianSamurai) for the game [Grey Hack](https://store.steampowered.com/app/605230/Grey_Hack/)!

All of the above probably doesn't tell you a thing, so please take a look at the features below 🤭👇

...Or, if you're already familiar with the language or are too curious, jump straight to the [Quick Start](#quick-start) 👀

# Features
There are several features **Wyvern** has to offer, which are shown below along with some simple examples ✨

For more complex thingies, you can see the [examples](examples) 🔍

## Type safety
**Wyvern** will back you up and prevent compiling if you've made a mistake 🌺
```rust
let a = 1;      // Inferred number
let b = "2";    // Inferred string

b = 2;          // Compilation error!
                // Can't assign number to a string variable

print(a + b);   // Compilation error!
                // Can't summate number and a string

print(a + cast<number>(b)); // Perfectly fine though!
print(a + b.val);           // Or even this (0.0 )
```
**MiniScript** would allow you to run the equivalent code and if it was a more complex program, you probably wouldn't notice the error until the runtime has taken place! 😥

## Object-oriented programming
Implement complex logic in a form of contracts, classes and objects 📃
```rust
object_oriented_programming.wyv
```

## MiniScript interoperability
Everything you know about **MiniScript** applies here! 🥰
```rust
let shell = get_shell();
let computer = shell.host_computer();
let file = computer.File("/etc/passwd");
if file != null {
    file.delete();
}
```
Not only that, but you can use **MiniScript** libraries in **Wyvern** programs! 😲

Let's say we have this little function in a hypothetical file called *msimport_example.src*:
```
msimport_example.src
```
Then, to use it in our **Wyvern** program, we write as follows:
```
msimport_example.wyv
```
This allows you to reuse existing code with all the advantages **Wyvern** has to offer! ❤️

## Zero runtime overhead
**Wyvern** compiles to an exact same code in **MiniScript** ahead-of-time and the performance remains the same as the latter! ✔️

# Quick Start
Simply copy-paste this nice little sequence in your real computer's console (assuming you have [Greybel-JS](https://github.com/ayecue/greybel-js) installed and **Grey Hack** opened) 💾
```
TODO
greybel build src/wyvic/wyvic.ms -id /root -ac -acp -ci
```

## Don't have Greybel-JS installed?
Then follow these easy steps to get your compiler up and running 👀
1. TODO
2. TODO
3. TODO

# Reference
Here is a [short summary](notes/Reference.md) of the language! 📔

# Known issues
This is a list of known **Wyvern** issues. Please do not ask me to fix those, I have no neccessary qualification for this! 🙅 <small><small><small>Maybe I will have one day...</small></small></small>

## Runtime error when casting from null
If you try to cast a potentially null value to something non-null, it may result in an runtime error
```rust
let a: string;          // Implicitly set to null
print(cast<number>(a)); // Runtime error!
```

# Credits
**Wyvern** is a project made solely by [H3xad3cimal](https://github.com/GuilhermeBrazilianSamurai)! My special thanks to you, you are awesome! 💖

I would also like to thank these people for making this little addition to it possible 👀

- Thanks [ayecue](https://github.com/ayecue) for [Greybel-JS](https://github.com/ayecue/greybel-js)!

You all are simply the best! 🥰
