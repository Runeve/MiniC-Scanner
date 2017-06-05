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
