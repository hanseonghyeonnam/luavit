import log from 'log'
import uv from 'uv'

print("CWD", uv.cwd())
for k, v in pairs(luavit.runtime()) do print(k , v) end

print(luavit.exists("./document.txt"))
log.log("x", "test")