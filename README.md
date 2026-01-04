# luavit
Luvit wrapper and syntax adder

---

## What is luavit?
It's the **luvit wrapper**, and **some syntax adder** for lua!

---

## Required
1. `gcc` (when you compiling self)
2. `luvit` any version, but luvit must in path (window) or /usr/local/bin. (linux) (luavit just calls luvit)

**WARNING:** luavit is tested on only linux. The mac, windows are not **tested**.

---

## What is 'added some syntax' mean?
I added some features in to the lua:


### New require syntax
|       Syntax      |    Sub syntax    |        End syntax      |                  Transpiled to                      |
| ----------------- | ---------------- | ---------------------- | --------------------------------------------------- |
| `import`          |	`<package name>` |  `from <package name>` |  `local <package name> = require("<package name>")` |

### Luavit APIs  
|        Name             |			                              Explain                                      |
| ----------------------- | -------------------------------------------------------------------------      |
| `luavit.stop()`         | Calls `os.exit()`.                                                             |
| `luavit.runtime()`      | Returns engine (`luavit-<luavit version>.<channel>`), wrapper (`luavit`).      |
| `luavit.args()`         | Returns argv, args.                                                            |
| `luavit.exists(str)`    | Returns true if <str> exists, false if <str> not exists.                       |
| `luavit.exec(str)`      | Executes <str>, return stdout of <str>.                                        |
| `luavit.isempty(str)`   | Returns true when <str> is nil or empty, false when <str> is not nil or empty. |
