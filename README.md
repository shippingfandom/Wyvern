> [!NOTE]
> This repository is a fork of the [original, probably discontinued project](https://github.com/GuilhermeBrazilianSamurai/Wyvern) by [H3xad3cimal](https://github.com/GuilhermeBrazilianSamurai).
> All credit for his hard work belongs to him and only him!
> I am responsible only for making this README and some other minor things!!!

# Wyvern

A [compiled](https://en.wikipedia.org/wiki/Compiled_language), [statically](https://en.wikipedia.org/wiki/Type_system#Static_type_checking) and [strong](https://en.wikipedia.org/wiki/Type_safety) typed, [inferred](https://en.wikipedia.org/wiki/Type_inference), [object-oriented](https://en.wikipedia.org/wiki/Object-oriented_programming) programming language written in [MiniScript](https://miniscript.org/) by [H3xad3cimal](https://github.com/GuilhermeBrazilianSamurai) for the game [Grey Hack](https://store.steampowered.com/app/605230/Grey_Hack/)!

All of the above probably doesn't tell you a thing so please take a look at the features below 🤭👇

...Or, if you're already familiar with the language or are too curious, jump straight to the [Quick Start](#quick-start) 👀

## Features
There are several features **Wyvern** has to offer, which are shown below along with some simple examples ✨

For more complex thingies, you can see the [examples](examples) 🔍

### Type safety
**Wyvern** will back you up and prevent compiling if you've made a mistake 🌺
```rust
// Inferred number
let a = 1;

// Inferred string
let b = "2";
```
```rust
// Compilation error!
// Can't assign number to a string variable
b = 2;
```
```rust
// Compilation error!
// Can't summate number and string
print(a + b);
```
```rust
// Perfectly fine though!
print(a + cast<number>(b));

// Or even this (0.0 )
print(a + b.val);
```
**MiniScript** would allow you to run the equivalent code, and if it was a more complex program, you probably wouldn't notice the error until the runtime has taken place! 😥

### Object-oriented programming
Implement complex logic in a form of contracts, classes and objects 📃
```rust
object_oriented_programming.wyv
```

### MiniScript interoperability
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

### Zero runtime overhead
**Wyvern** compiles to the equivalent code in **MiniScript** ahead-of-time and the runtime performance remains the same as the latter! ✔️

## Quick Start
Simply copy-paste this nice little sequence in your real computer's console (assuming you have [Greybel-JS](https://github.com/ayecue/greybel-js) installed and **Grey Hack** opened) 💾
```
git clone https://github.com/shippingfandom/Wyvern ; cd Wyvern ; greybel build src/wyvic/wyvic.ms -id /root -ac -acp -ci
```

### Don't have Greybel-JS installed?
No worries! Follow these simple steps to get your compiler up and running 👀
1. Open **Terminal.exe** 💻
2. Type in `sudo -s` and pass in your **root** password 💿
3. Type in `FileExplorer.exe` and go to the **/lib** directory 📁
4. Right click and choose **New Folder**. Name it **wyvern**. Go to it. You should end up in **/lib/wyvern** by now 😶
5. Right click and choose **New File**. Name it **namespace**. Copy the contents of [src/wyvern-lang/wyv-namespace.ms](src/wyvern-lang/wyv-namespace.ms) to the file you've just created 📃

Now you have to repeat the step 5 until you have all the needed files in **/lib/wyvern**... For our own mental health, here is a list of what you have to create and with what you have to populate 🤫

| Path in Grey Hack         | Name in [src/wyvern-lang/](src/wyvern-lang/)              |
|:--------------------------|:----------------------------------------------------------|
| /lib/wyvern/namespace     | [wyv-namespace.ms](src/wyvern-lang/wyv-namespace.ms)      |
| /lib/wyvern/utils         | [wyv-utils.ms](src/wyvern-lang/wyv-utils.ms)              |
| /lib/wyvern/diagnostics   | [wyv-diagnostics.ms](src/wyvern-lang/wyv-diagnostics.ms)  |
| /lib/wyvern/symbols       | [wyv-symbols.ms](src/wyvern-lang/wyv-symbols.ms)          |
| /lib/wyvern/syntax        | [wyv-syntax.ms](src/wyvern-lang/wyv-syntax.ms)            |
| /lib/wyvern/ast           | [wyv-ast.ms](src/wyvern-lang/wyv-ast.ms)                  |
| /lib/wyvern/builtins      | [wyv-builtins.ms](src/wyvern-lang/wyv-builtins.ms)        |
| /lib/wyvern/api           | [wyv-api.ms](src/wyvern-lang/wyv-api.ms)                  |
| /lib/wyvern/compiler      | [wyv-compiler.ms](src/wyvern-lang/wyv-compiler.ms)        |
| /lib/wyvern/wyvic.src     | [src/wyvic/wyvic.ms](src/wyvic/wyvic.ms)                  |

Phew! That was an interesting experience! 😅

Now you have all the project structure in your **/lib/wyvern**. Double click on **/lib/wyvern/wyvic.src**, single click at the triangle-like button on the upper left, change the **File name** to **wyvic** and press **SAVE** 💾

Congratulations! You have installed **wyvic** - the **Wyvern** compiler! 😜

### Want to build a program?

To compile a program made in **Wyvern**, type `wyvern -c YourAwesomeProgram.wyv --build` 💞

## Reference
Here is a [short summary](notes/Reference.md) of the language! 📔

## Known issues
This is a list of known **Wyvern** issues. Please do not ask me to fix those, I have no neccessary qualification for this! 🙅

### Runtime error when casting from null
If you try to cast a potentially null value to something non-null, it may result in a runtime error
```rust
let a: string;          // Implicitly set to null
print(cast<number>(a)); // Runtime error!
```

## Credits
**Wyvern** is a project made solely by [H3xad3cimal](https://github.com/GuilhermeBrazilianSamurai)! My special thanks to you, you are awesome! 💖

I would also like to thank these people for making this little addition to it possible 👀

- Thanks [ayecue](https://github.com/ayecue) for [Greybel-JS](https://github.com/ayecue/greybel-js)!

You all are simply the best! 🥰
