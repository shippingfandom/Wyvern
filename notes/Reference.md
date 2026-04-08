# Welcome to Wyvern!
Wyvern is a compiled, statically and strong typed, inferred, object-oriented programming language that has many additional features over MiniScript.

## Syntax
Always end statements with a *semicolon*.

Code blocks are delimited by *braces* (see below). Indentation matters only for the readability.

Comments begin with *//*.

Don't use empty parentheses around conditions in **if** or **while** blocks.

All variables are local unless specified with **var** keyword by default. Wyvern is case-sensitive.

## Control Flow

### if, else if, else
Use **if** blocks to do different things 
depending on some condition. Include 
zero or more **else if** blocks and one 
optional **else** block.
```rust
if 2 + 2 == 4 {
	print("Math works!");
} else if pi > 3 {
	print("Pi is tasty");
} else if "a".code < "b".code {
	print("I can sort");
} else {
	print("Last chance");
}
```

### while
Use a **while** block to loop as long as a condition is true.
```rust
let s: string = "Spam";
while s.len < 50 {
	s = s + ", spam";
}
print(s + " and spam!");
```

### foreach
A **foreach** loop can loop over any list, including ones easily created with the **range** function.
```rust
foreach let i: number in range(10, 1) {
	print(cast<string>(i) + "...");
}
print("All done! <3");
```

### for
A **for** loop can loop with an initialization variable and step as long as the condition is true.
```rust
for let i: number = 10; i > 0; i = i - 1 {
	print(cast<string>(i) + "...");
}
print("All done! <3");
```

### break & continue
The **break** statement jumps out of a **while**, **foreach** or **for** loop. The **continue** statement jumps to the top of the loop, skipping the rest of the current iteration.

## Data Types

### Booleans
Boolean is a logical value that represents *true* or *false*. Manifested with **bool**.

| Operators | Description |
|:----------|:------------|
| &&        | Logical AND |
| \|\|      | Logical OR  |
| !         | Logical NOT |
| ==, !=    | Comparision |

### Numbers
All numbers are stored in full-precision format. Numbers DO NOT represent *true* (1) and *false* (0) but can be casted to those with **cast\<bool\>**. Manifested with **number**.

| Operators            | Description         |
|:---------------------|:--------------------|
| +, -, *, /           | Standard arithmetic |
| %                    | Modulo (remainder)  |
| ^                    | Power               |
| ==, !=, >, >=, <, <= | Comparision         |

### Strings
Text is stored in strings of Unicode characters. Write strings by surrounding them with quotes. If you need to include a quotation mark in the string, escape it with **\\**.
```rust
print("OK, \"Bob\".");
```

| Operators      | Description                  |
|:---------------|:-----------------------------|
| +              | String concatenation         |
| *, /           | Replication, Division        |
| ==, !=         | Comparision                  |
| [i]            | Get character at index *i*   |
| slice(s, i, j) | Get slice from *i* up to *j* |

### Lists
Write a list in square brackets. Iterate over the list with **foreach**, or pull out individual items with a 0-based index in square brackets. A negative index counts from the end. Get a slice (subset) of a list with **slice** function.
```rust
let x = [2, 4, 6, 8];
x[0];			// 2
x[-1];			// 8
slice(x, 1, 3);	// [4, 6]
x[2] = 5;		// x is now [2, 4, 5, 8]
```

| Operators      | Description                      |
|:---------------|:---------------------------------|
| +              | List concatenation               |
| *, /           | Replication, Division            |
| [i]            | Get/set element at index *i*     |
| slice(s, i, j) | Get/set slice from *i* up to *j* |

### Maps
A map is a set of values associated with unique keys. Create a map with curly braces; get or set a single value with square brackets. Keys and values may be any type.
```rust
let m: number<string> = {
	1: "one",
	2: "two"
};
m[1];	// "one"
m[2] = "dos";
```

| Operators      | Description                      |
|:---------------|:---------------------------------|
| +              | Map concatenation                |
| [k]            | Get/set value with the key *k*   |

### Functions

## Classes & Objects

## Intrinsic Functions and Methods

### Numeric

### String

### List/Map

### Generic
