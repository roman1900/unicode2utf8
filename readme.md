# Unicode2UTF8
An implementation of the Unicode to UTF-8 encoding algorithm found on [Wikipedia.com](https://en.wikipedia.org/wiki/UTF-8#Encoding)

After encoding the string is formatted as [Percent-encoding](https://en.wikipedia.org/wiki/Percent-encoding) to be used within an URI.

This is useful when a json Unicode escaped character is included in a returned URI.

This repository provides examples in the following languages:
- [.Net Core console](NetCore)
- [Microsoft T-SQL](MsSQL)
