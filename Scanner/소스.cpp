#include<stdio.h>
#include<ctype.h>
#include<string.h>
#include<stdlib.h>
#include"scanner.h"

void main()
{
	char path[1000];
	strcpy(path, "prime.mc");
	fopen_s(&sourceFile, path, "r");
	tokenType token;
	printf("       Type        |    Token    |  Token number  |  Token value  |  File name  |  Line number  |  Column number\n");
	printf("----------------------------------------------------------------------------------------------------------------\n");
	do
	{
		token = scanner();
		if (token.number != teof)
		{
			if (token.comment_type == 0)
				printf("       Token       |  %7s    |  %7d       |  %7s      |  %5s   |   %5d       |    %5d\n", token.str, token.number, token.value, path, token.line_num, token.col_num);
			else if (token.comment_type == 1)
				printf("   Single - line   |  <%s>  \n", token.comment);
			else if (token.comment_type == 2)
				printf("    Multi - line   |  <%s>  \n", token.comment);
			else if (token.comment_type == 3)
				printf("Documented comments|  <%s>  \n", token.comment);
		}
	} while (token.number != teof);
}