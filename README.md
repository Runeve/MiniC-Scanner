# MiniC-Scanner

: ANSI C문법으로부터 몇 가지 구조를 축소한 Mini C언어의 Scanner.

### 1. 프로그램 명세
---------------------
: Mini C 소스코드(*mc)파일을 넣으면Token이 인식되어 다음 포맷과 같이 출력한다. 
 
여기서 Type은 Token, Single-Llne, Multi-line,Docummented commets 총 4가지가 있다.
Token을 제외한 나머지 주석 부분은 주석 부분만 출력된다.

#### ◈ 인식할 수 있는 Token

▷ 연산자 (Operator)


  +	사칙 연산자 : +, -, *, /, %

+	배정 연산자 : =, +=, -=, *=, /=, %=

+	논리 연산자 : !, &&, ||

+	관계 연산자 : ==, !=, <, >, <=, >=

+	증감 연산자 : ++, --

+	그 외 : 대괄호('[', ']'), 중괄호('{', '}'), 소괄호('(', ')'), 컴마(','), 세미콜론(';'), 콜론(‘:’)




▷ 지정어 (Keyword)

+	const, else, if, int, return, void, while, char, double, for, do, goto, switch, case, break, default


▷ 명칭(Identifier)

+	[a-zA-Z_][a-zA-Z0-9_]* 형태의 명칭을 인식

+	이미 의미와 용법이 지정되어 있는 예약어(Reserved Word)는 명칭으로 사용할 수 없다.



▷ 정수 상수 (Integer Constant)

+	10진수(Decimal Number) : 0으로 시작하지 않는 일반 숫자 형태

+	8진수(Octal Number) : 0으로 시작하는 형태의 숫자

+	16진수(Hexa-decimal Number) : 0x로 시작하는 숫자 혹은 알파벳 형태




#### ◈ 인식할 수 있는  주석 (Comment)

▷ Single – line Comment
+	// 형태로 시작하는 한 줄 형태의 주석

▷ Multi – line Comment
+	/*~*/ 형태로 시작하는 여러 개의 줄 형태의 주석

▷ Documented comments
+	/** ~ */형태로 시작하는 문서 형태의 주석

#### ◈ 인식할 수 있는 리터럴

▷ Interger literal
▷ Character literal
▷ String literal
▷ Double literal
+	부동 소수점과 지수 로그 e를 사용하는 double 형태를 decimal 값으로 바꾸어 value에 저장  






### 2.	프로그램 설계 / 알고리즘
---------------------
 
: Main함수는 *mc파일을 열어 파일을 끝까지 읽을 때까지 scanner를 호출한다. scanner에서 tokenType구조체를 반환하면 그 구조체의 comment type에 따라 Token type을 다르게 출력한다. tokenType의 구조는 다음과 같다.

|     Type    |         using                         |
|:----------------:|:--------------------------------:|
| char str[]       | token자체를 저장                 |
| int number       | token number를 저장              |
| char value[]     | 리터럴이 존재하면 저장, 아니면 0 |
| int line_num     | 라인 넘버를 저장                 |
| int col_num      | 콜론 넘버를 저장                 |
| int comment_type | Token Type저장                   |
| char comment     | comment일 때 주석 내용을 저장    |

### 3.	주요 코드 설명
---------------------
 
#### - main.cpp
>- main()
>: 프로그램이 시작되는 메소드. 파일을 열고 scanner()를 실행하여 token구조체를 반환 받아 종류에 따라 출력한다.
```
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
```
#### - scanner.h
:  실제 token 인식에 필요한 메소드가 있는 헤더파일
>- superLetter(char ch)
>: 지정어나 키워드 판단 함수. 영문자이거나 _이면 1, 아니면 0을 반환
```
int superLetter(char ch)
{
	if (isalpha(ch) || ch == '_') return 1;
	else return 0;
}
```
>- superLetterOrDigit(char ch)
>: 숫자 판단 함수. 숫자이거나 _이면 1, 아니면 0을 반환
```
int superLetterOrDigit(char ch)
{
	if (isalnum(ch) || ch == '_') return 1;
	else return 0;
}
```
>- isDigitOrPoint(char c)
>: 숫자나 숫자 표현에 사용된 문자인지 판단 함수. 숫자 표현에 사용된 문자는 소수점을 표현하는 . 이나 지수 로그 인 e나 E 그리고 16진수에 쓰인 x나 X 그리고 알파벳이다.
```
bool isDigitOrPoint(char c)
{
	if ((c >= '0' && c <= '9') || c == '.' || c == 'e' || c == 'E' || c == 'x' || c == 'X' || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))
		return true;
	else
		return false;
}
```
>- getNumber(char firstCharcter)
>: 숫자 리터럴의 값을 숫자로 변환해주는 함수
>: 처음 문자가 0이고 다음 숫자가 X나 x면 16진수로 판단해 hexValue함수를 이용해서 숫자 리터럴 value 를 계산한다. 그리고 0과 7 사이에 있으면 8진수로 간주해 8진수로 숫자 리터럴 value를 계산한다. 그리고 소수점이나 지수 로그 e가 있으면 소수점과 지수 로그를 이용해 value 를 계산한다.
>:처음 문자가 0 이 아니고 소수점이나 지수 로그가 없으면 decimal로 간주해 평범한 10진수로 value를 계산한다.
```
double getNumber(char firstCharacter)
{
	char* temp;
	double num = 0;
	int value;
	char ch;
	int point_count = 1;
	int i = 0; 
	temp_str[i++] = firstCharacter;
	if (firstCharacter == '0') {
		ch = fgetc(sourceFile);
		col_num++;
		if (ch != '\n' && isDigitOrPoint(ch))
			temp_str[i++] = ch;
		col_num++;
		if ((ch == 'X') || (ch == 'x')) {		// hexa decimal
			while ((value = hexValue(ch = fgetc(sourceFile))) != -1)
			{
				if (ch != '\n' && isDigitOrPoint(ch))
					temp_str[i++] = ch;
				col_num++;
				num = 16 * num + value;
			}
		}
		else if ((ch >= '0') && (ch <= '7'))	// octal
			do {
				num = 8 * num + (int)(ch - '0');
				ch = fgetc(sourceFile);
				col_num++;
				if (ch != '\n' && isDigitOrPoint(ch))
					temp_str[i++] = ch;
				col_num++;
			} while ((ch >= '0') && (ch <= '7'));
		else if (ch == '.' || ch == 'e' || ch == 'E')	//floating point
		{
			{
				point_check = true;
				do {
					if (ch == 'e' || ch == 'E')//using e
					{
						ch = fgetc(sourceFile);
						col_num++;
						if (ch != '\n' && isDigitOrPoint(ch))
							temp_str[i++] = ch;
						int temp = 0;
						do {
							temp = 10 * temp + (int)(ch - '0');
							ch = fgetc(sourceFile);
							col_num++;
							if (ch != '\n' && isDigitOrPoint(ch))
								temp_str[i++] = ch;
							col_num++;
						} while (isDigitOrPoint(ch));
						num *= pow(10, temp);
						if (num == (int)num)
							point_check = false;
					}
					else
					{
						if (ch >= '0' && ch <= '9')
							num += (double)(ch - '0') *(1.0 / (double)pow(10, (point_count++)));
						ch = fgetc(sourceFile);
						col_num++;
						if (ch != '\n' && isDigitOrPoint(ch))
							temp_str[i++] = ch;
						col_num++;
					}
				}while (isDigitOrPoint(ch));
			}
		}
		else num = 0;						// zero
	}
	else {									// decimal
		ch = firstCharacter;
		do {
			if (ch == '.' || ch == 'e' || ch == 'E' )					//floating point
			{
				point_check = true;
				do {
					if (ch == 'e' || ch == 'E')//using e
					{
						ch = fgetc(sourceFile);
						col_num++;
						if (ch != '\n' && isDigitOrPoint(ch))
							temp_str[i++] = ch;
						int temp = 0;
						do{
							temp = 10 * temp + (int)(ch - '0');
							ch = fgetc(sourceFile);
							col_num++;
							if (ch != '\n' && isDigitOrPoint(ch))
								temp_str[i++] = ch;
							col_num++;
						} while (isDigitOrPoint(ch));
						num *= pow(10, temp);
						if (num == (int)num)
							point_check = false;
					}
					else
					{
						if (ch >= '0' && ch <= '9')
							num += (double)(ch - '0') *(1.0 / (double)pow(10, (point_count++)));
						ch = fgetc(sourceFile);
						col_num++;
						if (ch != '\n' && isDigitOrPoint(ch))
							temp_str[i++] = ch;
						col_num++;
					}
				} while (isDigitOrPoint(ch));
			}
			else
			{
				num = 10 * num + (int)(ch - '0');
				ch = fgetc(sourceFile);
				if (ch != '\n' && isDigitOrPoint(ch))
					temp_str[i++] = ch;
				col_num++;
			}
		} while (isDigitOrPoint(ch));
	}
	ungetc(ch, sourceFile);  /*  retract  */
	return num;
}

```
>- lexicalError(int n)
: 오류를 판단하는 함수. 매개 변수에 따라 다른 오류 문구를 출력한다.
: 1번 에러는 지정어의 길이가 정한 것보다 길 때 오류를 출력한다.
: 2번에러는 다음 문자가 &이여야 하는 데 &이지 않을 때 오류를 출력한다. 이 코드에서는 &&이 나오지 않고 &이 하나만 인식이 될 때 이 오류를 출력한다.
: 3번 에러는 마찬가지로 다음 문자가 | 이어야 하는데 다른 문자가 왔을 때 오류를 출력한다. 이 코드에서는 || 이 아닌 | 한 문자만 나올 때 이 오류를 출력한다.
: 4번 에러는 어느 case에도 걸리지않고 인식이 되지 않을 때 출력한다.
```
void lexicalError(int n)
{
	printf(" *** Lexical Error : ");
	switch (n) {
	case 1: printf("an identifier length must be less than 12.\n");
		break;
	case 2: printf("next character must be &\n");
		break;
	case 3: printf("next character must be |\n");
		break;
	case 4: printf("invalid character\n");
		break;
	}
}

```

### 4.결과 / 결과분석
---------------------

: 몇 가지 코드만 전체 결과를 삽입하고 나머지는 의도한 특정 부분만 캡처했습니다. 그리고 추가 사항은 따로 mc를 만들어서 결과를 분석했습니다.
