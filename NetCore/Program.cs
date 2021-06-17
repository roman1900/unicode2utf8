using System;

namespace unicode2utf8
{
	class Program
	{

		static void Main(string[] args)
		{
			string unicode = "7176";
			uint uni_num = (uint)int.Parse(unicode, System.Globalization.NumberStyles.HexNumber);
			uint utf = 0;
            const uint SINGLE = 0x7F;
            const uint DOUBLE = 0x07FF;
            const uint TRIPLE = 0xFFFF;
            const uint WORD   = 0x10FFFF;

	        int byte_offset = 0;

            if (uni_num > WORD)
            {
                throw new Exception($"Unicode value provided {uni_num} is larger than the allowed upper UTF-8 limit {WORD} ");
            }
            byte_offset = uni_num <= SINGLE ? 0 : uni_num <= DOUBLE ? 1 : uni_num <= TRIPLE ? 2 : 3;
            
			if (byte_offset == 0)
			{
				utf = uni_num;
			}
			else
			{
				for(int lsb=0; lsb <= byte_offset; lsb++)
                {
                	utf = utf | ((128 | (uni_num & 0b111111)) << (8 * lsb));
					uni_num = uni_num >> 6;
				}
				uint bitshift = (uint)0xF << (7 - byte_offset) & 0xFF;
				utf = utf | bitshift << (8 * byte_offset);
			}
			
            Console.WriteLine($"utf bin: "+Convert.ToString(utf,2));
			Console.WriteLine($"utf: {utf:X8}");
            string utf8url = utf.ToString("X8");
            utf8url = String.Format($"%{utf8url.Substring(0,2)}%{utf8url.Substring(2,2)}%{utf8url.Substring(4,2)}%{utf8url.Substring(6,2)}").Replace("%00","");
            Console.WriteLine($"url encoded: {utf8url}");

		}
	}
}
