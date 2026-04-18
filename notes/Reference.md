# Welcome to Wyvern!
Wyvern is a compiled, statically and strong typed, ~~inferred~~, object-oriented programming language that has many additional features over MiniScript.

## Syntax
Always end statements with a *semicolon*.

Code blocks are delimited by *braces* (see below). Indentation matters only for the readability.

Comments begin with *//*.

Don't use empty parentheses around conditions in **if**, **switch**, **for** or **while** blocks.

All variables are global unless specified with **let** keyword by default. Wyvern is case-sensitive.

## Control Flow

### if, else if, else
Use **if** blocks to do different things depending on some condition. Include zero or more **else if** blocks and one optional **else** block.
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

### switch, case
Use **switch** blocks to evaluate a single expression and branch execution to the first matching **case** label. Include optional **default** block. 
```rust
let s: string = "Lots";
switch s {
	case "Lots":
		print(s + " of love! <3");
		break;
	case null:
		print("Much appreciation!");
		break;
	default:
		print("Need more positivity!");
		break;
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

### do while
Use **do while** block to execute a block of code at least once before checking a condition at the end, repeating the loop as long as the condition is true.
```rust
let ones: number[] = [];
do {
	ones.push(1);
} while ones.len < 10;
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
A **for** loop can loop with an initialization variable and a step as long as the condition is true.
```rust
for let i: number = 10; i > 0; i = i - 1 {
	print(cast<string>(i) + "...");
}
print("All done! <3");
```

### break & continue
The **break** statement jumps out of a **while**, **do while**, **foreach** or **for** loop. The **continue** statement jumps to the top of the loop skipping the rest of the current iteration.

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
| &                    | Bitwise AND         |
| \|                   | Bitwise OR          |
| ~                    | Bitwise NOT         |
| <<                   | Left shift          |
| >>                   | Right shift         |

### Strings
Text is stored in strings of Unicode characters. Write strings by surrounding them with quotes. If you need to include a quotation mark in the string, escape it with **\\**. Manifested with **string**.
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
Write a list in square brackets. Iterate over the list with **foreach**, or pull out individual items with a 0-based index in square brackets. A negative index counts from the end. Get a slice (subset) of a list with **slice** function. Manifested with **itemT\[\]**.
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
A map is a set of values associated with unique keys. Create a map with curly braces; get or set a single value with square brackets. Keys and values may be any type. Manifested with **keyT\<valueT\>**.
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
Create a function with **fn** keyword, give it a name,  include parameters with types and optional default values in *brackets*, after the *arrow* specify the return type. Invoke by using that name and *brackes*, either empty or with arguments. Use a function name to reference it without invoking. Manifested with **reference**.
```rust
fn Triple(n: number = 1) -> number {
	return n * 3;
}
print(Triple());			// 3
print(Triple(5));			// 15
let f: reference = Triple;
print(f(5));				// Also 15
```

## User specified types

### Structures
A **struct** groups related data fields into a single custom type, allowing you to bundle different values together under one name.

```rust
struct Vec2 {
	let x: number;
	let y: number;
}

fn Add(a: Vec2, b: Vec2) -> Vec2 {
	return new Vec2 {
		x: a.x + b.x,
		y: a.y + b.y
	};
}

let a: Vec2 = new Vec2 {
	x: 12,
	y: 3
};
let b: Vec2 = new Vec2 {
	x: 5,
	y: 6
};

let c: Vec2 = Add(a, b);
print([c.x, c.y]); // [17, 9]
```

### Enumerations
An **enum** is a fixed set of named number constants, starting from **0** unless specified otherwise.

```rust
enum ErrorCode {
    FILE_MISSING,
    INCORRECT_PASSWORD = 13,
    SOMETHING_ELSE
}

let codeA: ErrorCode = ErrorCode.FILE_MISSING;
let codeB: ErrorCode = ErrorCode.INCORRECT_PASSWORD;
let codeC: ErrorCode = ErrorCode.SOMETHING_ELSE;
print([codeA, codeB, codeC]); // [0, 13, 14]
```

### Classes & Objects
A **class** is a blueprint for creating objects — instances that bundle data and behavior. Members with **public** modifier are accessible from anywhere, while **private** members are hidden within the **class** and it's children. Members with **static** modifier belong to the **class** itself, not to any object instance. Methods that are **virtual** can be overridden in the derived **classes**, where **override** explicitly replaces the base **class** implementation. The **class** can inherit from no more than one **class**.

To construct an instance of the **class**, use the **new** keyword.

To access methods and properties of the parent **class**, use **super** keyword.

To call the constructor of the parent **class**, call **super.\_\_constructor\_\_(a1, a2, a3, ...)**.

Here is a complete **classes & objects** usage example.

```rust
class Entity {
	private let _speed: number;

	public fn Speed() -> number {
		return self._speed;
	}
	public virtual fn Talk() -> void;

	fn Entity(speed: number) -> void {
		self._speed = speed;
	}

    public static virtual fn Summon() -> Entity;
}

class Cat: Entity {
	public override fn Talk() -> void {
		print("Meow :3");
	}

	fn Cat() -> void {
        super.__constructor__(108111118101);
	}

    public static override fn Summon() -> Entity {
        return new Cat();
    }
}

class Sentient: Entity {
	public override fn Talk() -> void {
		print("Hello, sentient being!");
	}

	fn Sentient() -> void {
		super.__constructor__(1337);
	}

    public static override fn Summon() -> Entity {
        return new Sentient();
    }
}

let entities: Entity[] = [Cat.Summon(), Sentient.Summon()];
foreach let entity: Entity in entities {
	print(entity.Speed());
	entity.Talk();
}
```

### Contracts (Interfaces)
A **contract** defines a set of methods and properties that a **class** must implement, without providing any implementation itself. A **class** implements a **contract** to guarantee a specific behavior. Unlike **classes**, **contracts** cannot have constructors, and a **class** can implement multiple **contracts**.

```rust
contract Printable {
	public fn Print() -> void;
}

class Figure $ Printable {
	public fn Print() -> void {
		print("Figure!");
	}
}

class Entity $ Printable {
	public fn Print() -> void {
		print("Entity!");
	}
}

let printables: Printable[] = [
	new Figure(), new Entity()
];
foreach let p: Printable in printables {
	p.Print();
}
```

## Intrinsic Functions and Methods

### Numeric
<table>
    <tr>
        <td>abs(x)</td>
        <td>acos(x)</td>
        <td>asin(x)</td>
    </tr>
    <tr>
        <td>atan(y, x)</td>
        <td>ceil(x)</td>
        <td>char(i)</td>
    </tr>
    <tr>
        <td>cos(r)</td>
        <td>floor(x)</td>
        <td>log(x, b)</td>
    </tr>
    <tr>
        <td>round(x, d)</td>
        <td>rnd()</td>
        <td>rnd(seed)</td>
    </tr>
    <tr>
        <td>pi</td>
        <td>sign(x)</td>
        <td>sin(r)</td>
    </tr>
    <tr>
        <td>sqrt(x)</td>
        <td>str(x)</td>
        <td>tan(r)</td>
    </tr>
</table>

### String
<table>
    <tr>
        <td>.indexOf(s)</td>
        <td>.insert(i, s)</td>
    </tr>
    <tr>
        <td>.len</td>
        <td>.val</td>
    </tr>
    <tr>
        <td>.code</td>
        <td>.remove(s)</td>
    </tr>
    <tr>
        <td>.lower()</td>
        <td>.upper()</td>
    </tr>
    <tr>
        <td>.replace(a, b)</td>
        <td>.split(d)</td>
    </tr>
</table>

### List/Map
<table>
    <tr>
        <td>.hasIndex(i)</td>
        <td>.indexOf(x)</td>
    </tr>
    <tr>
        <td>.insert(i, v)</td>
        <td>.join(s)</td>
    </tr>
    <tr>
        <td>.push(x)</td>
        <td>.pop()</td>
    </tr>
    <tr>
        <td>.pull()</td>
        <td>.indexes</td>
    </tr>
    <tr>
        <td>.values</td>
        <td>.len</td>
    </tr>
    <tr>
        <td>.sum()</td>
        <td>.sort()</td>
    </tr>
    <tr>
        <td>.shuffle()</td>
        <td>.remove(i)</td>
    </tr>
    <tr>
        <td></td>
        <td>range(from, to, step)</td>
    </tr>
</table>

### Generic
<table>
    <tr>
        <td>print(a)</td>
        <td>time</td>
        <td>wait(sec)</td>
    </tr>
    <tr>
        <td>locals</td>
        <td>outer</td>
        <td>globals</td>
    </tr>
    <tr>
        <td>yield()</td>
        <td>cast&lt;T&gt;(a)</td>
        <td>unsafe_cast&lt;T&gt;(a)</td>
    </tr>
</table>

### Cast types
<table>
    <tr>
        <td>reference</td>
        <td>bool</td>
        <td>number</td>
        <td>string</td>
    </tr>
    <tr>
        <td>any</td>
        <td>library</td>
        <td>computer</td>
        <td>router</td>
    </tr>
    <tr>
        <td>file</td>
        <td>port</td>
        <td>shell</td>
        <td>ftpshell</td>
    </tr>
    <tr>
        <td>metalib</td>
        <td>netsession</td>
        <td>wallet</td>
        <td>metamail</td>
    </tr>
    <tr>
        <td>coin</td>
        <td>subwallet</td>
        <td>aptclient</td>
        <td>metaxploit</td>
    </tr>
    <tr>
        <td></td>
        <td>crypto</td>
        <td>blockchain</td>
        <td>service</td>
    </tr>
</table>
