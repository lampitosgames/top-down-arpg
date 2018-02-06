<?xml version="1.0" encoding="UTF-8"?>
<tileset name="template" tilewidth="64" tileheight="64" tilecount="64" columns="8">
 <image source="template-assets/tileset.png" width="512" height="512"/>
 <terraintypes>
  <terrain name="mines" tile="9"/>
 </terraintypes>
 <tile id="0" terrain=",,,0">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0">
    <polyline points="0,0 0,64 16,64 16,16 64,16 64,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="1" terrain=",,0,0">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0">
    <polyline points="0,0 0,16 64,16 64,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="2" terrain=",,0,">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0">
    <polyline points="0,0 64,0 64,64 48,64 48,16 0,16 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="3" terrain="0,0,0,">
  <objectgroup draworder="index">
   <object id="1" x="48" y="64">
    <polyline points="0,0 0,-16 16,-16 16,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="4" terrain="0,0,,0">
  <objectgroup draworder="index">
   <object id="1" x="0" y="48">
    <polyline points="0,0 16,0 16,16 0,16 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="8" terrain=",0,,0">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0">
    <polyline points="0,0 0,64 16,64 16,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="9" terrain="0,0,0,0"/>
 <tile id="10" terrain="0,,0,">
  <objectgroup draworder="index">
   <object id="1" x="48" y="0">
    <polyline points="0,0 0,64 16,64 16,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="11" terrain="0,,0,0">
  <objectgroup draworder="index">
   <object id="1" x="48" y="0">
    <polyline points="0,0 0,16 16,16 16,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="12" terrain=",0,0,0">
  <objectgroup draworder="index">
   <object id="1" x="0" y="16">
    <polyline points="0,0 16,0 16,-16 0,-16 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="16" terrain=",0,,">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0">
    <polyline points="0,0 0,64 64,64 64,48 16,48 16,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="17" terrain="0,0,,">
  <objectgroup draworder="index">
   <object id="1" x="0" y="48">
    <polyline points="0,0 64,0 64,16 0,16 0,0"/>
   </object>
  </objectgroup>
 </tile>
 <tile id="18" terrain="0,,,">
  <objectgroup draworder="index">
   <object id="1" x="48" y="0">
    <polyline points="0,0 0,48 -48,48 -48,64 16,64 16,0 0,0"/>
   </object>
  </objectgroup>
 </tile>
</tileset>
