import zipfile,struct,sys
src,dst=sys.argv[1],sys.argv[2]
zin=zipfile.ZipFile(src)
out=open(dst,'wb');central=[]
for info in zin.infolist():
    data=zin.open(info).read()
    comp=info.compress_type
    if comp==zipfile.ZIP_DEFLATED:
        import zlib
        c=zlib.compressobj(9,zlib.DEFLATED,-15);payload=c.compress(data)+c.flush()
    else: payload=data
    crc=zipfile.crc32(data)&0xffffffff
    name=info.filename.encode('utf-8')
    off=out.tell()
    extra=b''
    if comp==zipfile.ZIP_STORED:
        pad=(4-(off+30+len(name))%4)%4; extra=b'\0'*pad
    flags=0x800
    out.write(struct.pack('<IHHHHHIIIHH',0x04034b50,20,flags,comp,0,0x21,crc,len(payload),len(data),len(name),len(extra))+name+extra+payload)
    central.append((name,comp,crc,len(payload),len(data),off,flags))
cd=out.tell()
for name,comp,crc,cs,us,off,flags in central:
    out.write(struct.pack('<IHHHHHHIIIHHHHHII',0x02014b50,20,20,flags,comp,0,0x21,crc,cs,us,len(name),0,0,0,0,0,off)+name)
cdsize=out.tell()-cd
out.write(struct.pack('<IHHHHIIH',0x06054b50,0,0,len(central),len(central),cdsize,cd,0))
out.close();print('aligned',len(central),'entries')
