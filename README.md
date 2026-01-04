# luavit
Luvit wrapper and syntax adder

---

## What is luavit?
It's the **luvit wrapper**, and **some syntax adder** for lua!

---

## Requirements
- gcc*, luvi* (only if compiling from source)
- luvit (any version) must be installed and in your PATH
  - Linux: /usr/local/bin/luvit
  - Windows: must be in system PATH

**WARNING:** luavit is tested on only linux. Mac & Windows are **not tested**.

---

## Configs & Flags
- luavit.json (not needed)
  - NonMemoryExecution:<boolean [default: false]
    - If true, creates `<file name>.transpiled.lua` file in the working directory when it transpiles. If false, Creates random tmp file. **This option is just made for some users who can't use tmp file, or working file!**
- --s, -s
  - When NonMemoryExecution is true, This option makes to not deleted trnaspiled file **for debugging.**

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
---

### Let's start!
1. Clone this repo.
   > `git clone https://github.com/hanseonghyeonnam/luavit.git`
2. Just move luavit in bin folder to /usr/local/bin for global use!
   > If self compiling, just enter 'make' in to the shell, in luavit folder! (**NOT A wrapper folder!**)
3. Testing!
   > In **test folder**, run `luavit test.lua`
4. **ENJOY!**

---

### Copyright
There is no copyright, **free 2 use!**
