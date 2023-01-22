import * as std from 'std';

const inputFile = scriptArgs[1];
const firmwareName = scriptArgs[2];

let input = (std.loadFile(inputFile) || '')
    .split('\n')
    .map(x => x.trim())
    .filter(x => x)
    ;

for (let line of input) {
    let pos = line.indexOf(firmwareName);
    if (pos < 0) continue;
    let id = line.substring(0, pos);
    let m = id.match(/[0-9][0-9a-f]*/i);
    print(m[0]);
    break;
}
