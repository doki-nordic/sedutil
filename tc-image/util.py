import sys
import re
import uuid
from pathlib import Path

def vmdk():
    img = Path(sys.argv[2])
    size = img.stat().st_size
    text = vmdk_template
    text = text.replace('{{cid}}', str(uuid.uuid4()).split('-')[0])
    text = text.replace('{{sectors}}', str(size // 512))
    text = text.replace('{{file}}', img.name)
    text = text.replace('{{uuid}}', str(uuid.uuid5(uuid.NAMESPACE_URL, 'file://' + str(img.resolve()))))
    with open(img.with_suffix('.vmdk'), 'w') as f:
        f.write(text)
    print(str(img.with_suffix('.vmdk')))

def get_loop():
    cnt = sys.stdin.read()
    sys.stderr.write(cnt)
    m = re.search(r'\/dev\/loop[0-9]+', cnt)
    print(m.group(0))

def get_mnt():
    cnt = sys.stdin.read()
    sys.stderr.write(cnt)
    m = re.search(r'/media/\S+', cnt)
    print(m.group(0))

# https://github.com/libyal/libvmdk/blob/main/documentation/VMWare%20Virtual%20Disk%20Format%20(VMDK).asciidoc
vmdk_template = '''# Disk DescriptorFile
version=1
CID={{cid}}
parentCID=ffffffff
createType="partitionedDevice"

# Extent description
RW {{sectors}} FLAT "{{file}}" 0

# The disk Data Base 
#DDB

ddb.virtualHWVersion = "4"
ddb.adapterType="ide"
ddb.geometry.cylinders="16383"
ddb.geometry.heads="16"
ddb.geometry.sectors="63"
ddb.uuid.image="{{uuid}}"
ddb.uuid.parent="00000000-0000-0000-0000-000000000000"
ddb.uuid.modification="00000000-0000-0000-0000-000000000000"
ddb.uuid.parentmodification="00000000-0000-0000-0000-000000000000"
'''

f = globals()[sys.argv[1]]
f()
