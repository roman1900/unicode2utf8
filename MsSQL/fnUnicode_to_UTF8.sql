ALTER FUNCTION fnUnicode_To_UTF8 
(
	@unicode nvarchar(6)
)
RETURNS varchar(12)
AS
BEGIN
	declare @uni_num int = convert(int,(convert(varbinary,right('000000'+@unicode, 6),2)));
	declare @byte_offset int = 0;
	declare @utf int = 0;
	declare @bitmask int = 63; -- 6 bit mask
	declare @bitshift int = 0xF; -- The byte mask required for the first byte
	declare @utfhex varchar(12);
	declare @uriencoded varchar(12);
	

	if @uni_num > 0x10FFFF return cast('Unicode value provided is too large' as int); --FORCE an error condition
	select @byte_offset = case	when @uni_num <= 0x7f --SINGLE BYTE
								then 0
								when @uni_num <= 0x07FF --DOUBLE BYTE
								then 1
								when @uni_num <= 0xFFFF -- TRIPLE BYTE
								then 2
								when @uni_num <= 0x10FFFF -- WORD
								then 3
						  end;
	if @byte_offset = 0 -- Single Byte unicode below 0x7f matches UTF-8 value
		set @utf = @uni_num;
	else
	begin
		declare @lsb int = 0;
		while (@lsb <= @byte_offset)
		begin
			select @utf = @utf | dbo.fnBitShift((128 | (@uni_num & @bitmask)),-8 * @lsb);
			set @lsb = @lsb + 1;
			select @uni_num = dbo.fnBitShift(@uni_num,6); 
		end
		select @bitshift = dbo.BitShift(@bitshift,-(7 - @byte_offset)) & 0xFF; 
		select @utf = @utf | dbo.BitShift(@bitshift,-(8 * @byte_offset)); 
	end;
	select @utfhex = convert(varchar(12),convert(varbinary,@utf),2)
	while left(@utfhex,2) = '00'
		select @utfhex = right(@utfhex,len(@utfhex)-2)
	while len(@utfhex) > 0
		select @uriencoded = isnull(@uriencoded,'') + '%' + left(@utfhex,2), @utfhex = right(@utfhex,len(@utfhex)-2);
	
	RETURN @uriencoded;

END