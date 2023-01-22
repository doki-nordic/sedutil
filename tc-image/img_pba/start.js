import * as std from 'std';
import * as os from 'os';

const EIO = 5;
const EEXIST = 17;

const inputFile = scriptArgs[1];
const outputFile = scriptArgs[2];
const mountDir = scriptArgs[3];

function errno(result, allowed) {
    allowed = allowed || [];
    if (result < 0 && allowed.indexOf(-result) < 0) {
        throw new Error(`System error ${-result}: ${std.strerror(-result)}`);
    }
}

function countParts(text) {
    let result = 0;
    while (text.length) {
        let m = text.match(/^(?:[^0-9]|[0-9]+)/i);
        text = text.substring(m[0].length);
        result++;
    }
    return result;
}

function saveFile(file, content) {
    let err = {};
    let f = std.open(file, 'wb', err);
    if (f == null || err.errno != 0) {
        errno(-Math.abs(err.errno) || EIO);
    }
    f.puts(content);
    f.close();
}

let input = (std.loadFile(inputFile) || '')
    .split('\n')
    .map(x => x.trim())
    .filter(x => x)
    ;

let devs = os.readdir('/dev/')[0]
    .filter(x => !x.startsWith('.'))
    ;

let maxParts = -1;
let matching = [];

for (let unlocked of input) {
    for (let devName of devs) {
        let dev = `/dev/${devName}`;
        if (dev.startsWith(unlocked)) {
            let rest = dev.substring(unlocked.length);
            let parts = countParts(rest);
            if (parts == maxParts) {
                matching.push(dev);
            } else if (parts > maxParts) {
                matching = [dev];
                maxParts = parts;
            }
        }
    }
}

matching.sort();
matching.reverse();

let partitions = [];

for (let i = 0; i < matching.length; i++) {
    let part = matching[i];
    let dir = `${mountDir}/${i}`;
    errno(os.mkdir(dir), [EEXIST]);
    let code = os.exec(['mount', '-o', 'ro', part, dir]);
    if (code < 0) {
        print(`${part} -> ${dir}: Executing mount command failed!`);
        continue;
    } else if (code > 0) {
        print(`${part} -> ${dir}: Mount command error!`);
        continue;
    }
    print(`${part} -> ${dir}: Mount success!`);
    let [files, res] = os.readdir(dir);
    if (res != 0) {
        print(`${part} -> ${dir}: Read error!`);
        continue;
    }
    partitions.push(dir);
}

saveFile(outputFile, partitions.join('\n') + '\n');
