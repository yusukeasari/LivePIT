package ws.fossette.PIT{
	import ws.fossette.PIT.*;
        /**
         * SFMT 擬似乱数ライブラリ簡易版の移植
         * @author Takeya Kimura
         * @version 0.01
         * @see http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/index-jp.html
         * @see http://www001.upp.so-net.ne.jp/isaku/rand2.html
         */
        public class Sfmt
        {
                private var index:int;
                private var x:Vector.<int> = new Vector.<int>(624);//状態テーブル
               
                /**
                 * コンストラクタ<br />
                 * 初期化する
                 * @param       s       整数のシード
                 */
                public function Sfmt(s:int)
                {
                        initMt(s);
                }
               
                private function genRandAll():void
                {
                        var a:int = 0;
                        var b:int = 488;
                        var c:int = 616;
                        var d:int = 620;
                        var y:int;
                        var p:Vector.<int> = x;//Javaの振る舞い、処理の内容からシャローコピーと判断
                       
                        do
                        {
                                y = p[a + 3] ^ (p[a + 3] << 8) ^ (p[a + 2] >>> 24) ^ ((p[b + 3] >>> 11) & 0xbffffff6);
                                p[a + 3] = y ^ (p[c + 3] >>> 8) ^ (p[d + 3] << 18);
                                y = p[a + 2] ^ (p[a + 2] << 8) ^ (p[a + 1] >>> 24) ^ ((p[b + 2] >>> 11) & 0xbffaffff);
                                p[a + 2] = y ^ ((p[c + 2] >>> 8) | (p[c + 3] << 24)) ^ (p[d + 2] << 18);
                                y = p[a + 1] ^ (p[a + 1] << 8) ^ (p[a] >>> 24) ^ ((p[b + 1] >>> 11) & 0xddfecb7f);
                                p[a + 1] = y ^ ((p[c + 1] >>> 8) | (p[c + 2] << 24)) ^ (p[d + 1] << 18);
                                y = p[a] ^ (p[a] << 8) ^ ((p[b] >>> 11) & 0xdfffffef);
                                p[a] = y ^ ((p[c] >>> 8) | (p[c + 1] << 24)) ^ (p[d] << 18);
                                c = d;
                                d = a;
                                a += 4;
                                b += 4;
                                if (b == 624) b = 0;
                        }
                        while (a != 624);
                }
               
                private function periodCertification():void
                {
                        var work:int;
                        var inner:int = 0;
                        var i:int;
                        var j:int;
                        var parity:Vector.<int> = new Vector.<int>(4);
                       
                        parity.push(0x00000001);
                        parity.push(0x00000000);
                        parity.push(0x00000000);
                        parity.push(0x13c9e684);
                        index = 624;
                       
                        for (i = 0; i < 4; i++)
                        {
                                inner ^= x[i] & parity[i];
                        }
                        for (i = 16; i > 0; i >>>= 1)
                        {
                                inner ^= inner >>> i;
                        }
                        inner &= 1;
                        if (inner == 1) return;
                        for (i = 0; i < 4; i++)
                        {
                                for (j = 0, work = 1; j < 32; j++, work <<= 1 )
                                {
                                        if ((work & parity[i]) != 0)
                                        {
                                                x[i] ^= work;
                                                return;
                                        }
                                }
                        }
                       
                }
               
                /**
                 * 初期化
                 * @param       s       整数のシード
                 */
                private function initMt(s:int):void
                {
                        x[0] = s;
                        for (var p:int; p < 624; p++)
                        {
                                s = 1812433253 * (s ^ (s >>> 30)) + p;
                                x[p] = s;
                        }
                        periodCertification();
                }
               
                /**
                 * 32ビット符号あり整数乱数を返す
                 * @return 32ビット符号あり整数乱数
                 */
                public function nextMt():int
                {
                        if (index == 624)
                        {
                                genRandAll();
                                index = 0;
                        }
                        return x[index++];
                }
               
                /**
                 * 0 以上 n 未満の整数乱数を返す
                 * @param       n       乱数の上限値にする整数
                 * @return      0 以上 n 未満の整数乱数
                 */
                public function nextInt(n:int):int
                {
                        var z:Number = nextMt();
                        if (z < 0) z += 4294967296.0;
                        return int(n * (1.0 / 4294967296.0) * z);
                }
               
                /**
                 * 0 以上 1 未満の乱数(53ビット精度)を返す
                 * @return      0 以上 1 未満の乱数(53ビット精度)
                 */
                public function nextUnif():Number
                {
                        var z:Number = nextMt() >>> 11;
                        var y:Number = nextMt();
                        if (y < 0) y += 4294967296.0;
                        return (y * 2097152.0 + z) * (1.0 / 9007199254740992.0);
                }
               
        }
       
}
