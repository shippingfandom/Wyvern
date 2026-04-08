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
let x: number[] = [2, 4, 6, 8];
x[0];			// 2
x[-1];			// 8
slice(x, 1, 3);	// [4, 6]
x[2] = 5;		// Now x is [2, 4, 5, 8]
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
Create a function with **fn** keyword, give it a name,  include parameters with types and optional default values in *brackets*, after the *arrow* specify the return type. Invoke by using that name and *brackes*, either empty or with arguments. Use a function name to reference it without invoking.
```rust
fn Triple(n: number = 1) -> number {
	return n * 3;
}
print(Triple());			// 3
print(Triple(5));			// 15
let f: reference = Triple;
print(f(5));				// Also 15
```

## Classes & Objects
A class is a user specified type. It can have **public** and **private** fields, as well as **virtual** and **static** ones; **public** fields are accessible outside of the class, while **private** ones are accessible only inside of the class and it's children. Use **override** if you want to change a field from a parent class. A method with no access modifiers and with the same name as the class is a constructor of this class.

An object is an instance of a class. To create an object, use **new** keyword.
```rust
class Shape {
	public let name = "Shape";
	private let _sides = 0;

	public fn Sides() -> number {
		return self._sides;
	}
	public fn Degrees() -> number {
		return 180 * (self._sides - 2);
	}
}

class Square: Shape {
	public override let name = "Square";
	private override let _sides = 4;
}

let x: Shape = new Square();
print(x.name);		// Square
print(x.Sides());	// 4
print(x.Degrees());	// 360
```

## Intrinsic Functions and Methods

### Numeric
|             |          |            |
|:------------|:---------|:-----------|
| abs(x)      | acos(x)  | asin(x)    |
| atan(y, x)  | ceil(x)  | char(i)    |
| cos(r)      | floor(x) | log(x, b)  |
| round(x, d) | rnd()    | rnd(seed)  |
| pi          | sign(x)  | sin(r)     |
| sqrt(x)     | str(x)   | tan(r)     |

### String
|                |               |
|:---------------|:--------------|
| .indexOf(s)    | .insert(i, s) |
| .len           | .val          |
| .code          | .remove(s)    |
| .lower()       | .upper()      |
| .replace(a, b) | .split(d)     |

### List/Map
|               |                       |
|:--------------|:----------------------|
| .hasIndex(i)  | .indexOf(x)           |
| .insert(i, v) | .join(s)              |
| .push(x)      | .pop()                |
| .pull()       | .indexes              |
| .values       | .len                  |
| .sum()        | .sort()               |
| .shuffle()    | .remove(i)            |
|               | range(from, to, step) |

### Generic
|          |              |                     |
|:---------|:-------------|:--------------------|
| print(a) | time         | wait(sec)           |
| locals   | outer        | globals             |
| yield()  | cast\<T\>(a) | unsafe_cast\<T\>(a) |

### Cast types
|           |            |            |            |
|:----------|:-----------|:-----------|:-----------|
| reference | bool       | number     | string     |
| any       | library    | computer   | router     |
| file      | port       | shell      | ftpshell   |
| metalib   | netsession | wallet     | metamail   |
| coin      | subwallet  | aptclient  | metaxploit |
|           | crypto     | blockchain | service    |
