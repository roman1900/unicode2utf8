/*
 	A function to perform << and >> bit shift operations in SQL
	A negative shift is equivalent to <<
	A positive shift is equivalent to >>
	Any bits shifted out and not wrapped around
*/
CREATE FUNCTION [dbo].[fnBitShift]
(
	@Num INT
	, @Shift SMALLINT
)
RETURNS INT
AS
BEGIN
	Declare @BigNum BIGINT = @Num;
	While @Shift != 0
		Select @BigNum = Case When Sign(@Shift) > 0
			Then (@BigNum - (@BigNum & 1)) / 2
			Else (@BigNum - (@BigNum & 0x80000000)) * 2
			End, @Shift -= Sign(@Shift);
	Return Cast(SubString(CAST(@BigNum as Binary(8)),5,4) as INT);
END