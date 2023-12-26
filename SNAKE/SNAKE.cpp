//md写的太傻逼了 改一句话顺序都不行 纯他妈优先级勉强撑住

#include <iostream>
#include <Windows.h>
#include <conio.h>//控制台输入输出头文件
//1 head
//2 body
//0 air
//3 cake
//4 edge ####
int cx, cy;
int sx, sy;
int score = 0;
using namespace std;
const int height = 24;
const int weight = 78;
int map[height][weight] = {0};
int life[height][weight] = { 0 };
int legth = 2;
bool cake = 0;
bool over = 0;
char pre_key, key;
void HideCursor()
{
	HANDLE handle = GetStdHandle(STD_OUTPUT_HANDLE);
	CONSOLE_CURSOR_INFO CursorInfo;
	GetConsoleCursorInfo(handle, &CursorInfo);//获取控制台光标信息
	CursorInfo.bVisible = false; //隐藏控制台光标
	SetConsoleCursorInfo(handle, &CursorInfo);//设置控制台光标状态
}

void gotoxy(short x, short y) {
	COORD coord = { x, y };
	//COORD是Windows API中定义的一种结构体类型，表示控制台屏幕上的坐标。
	//上面语句是定义了COORD类型的变量coord，并以形参x和y进行初始化。
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
	//GetStdHandle(STD_OUTPUT_HANDLE); 获取控制台输出句柄
	//然后用SetConsoleCursorPosition设置控制台(cmd)光标位置
}

int print() {
	
	
	for (size_t y = 0; y < height; y++)
	{
		for (size_t x = 0; x < weight; x++)
		{
			
			switch (map[y][x])
			{
			case(1):
				gotoxy(x, y);
				printf("O");
				break;
			case(2):
				gotoxy(x, y);
				printf("o");
				break;
			case(0):
				gotoxy(x, y);
				printf(" ");
				break;
			case(3):
				gotoxy(x, y);
				printf("*");
				break;
			case(4):
				gotoxy(x, y);
				printf("#");
				break;
			default:
				break;
			
			}
			
		}
		if (y == height / 2) {
			printf("score:%d", score);
		}
		cout << " " << endl;
	}
	
	
	return 0;
}
int isdead() {
	if (map[sy][sx] == 2) {
		over = 1;
	}
	
	return 0;
}
int spwancake() {
	cake = 1;
	srand(time(nullptr));
	cx = (rand() % ((weight - 1) - 1)) + 1;
	cy = (rand() % ((height - 1) - 1)) + 1;
	/*if (map[cy][cx] != 0) {
		map[cy][cx] = 3;
	}
	else {
		spwancake();
	}*/
	map[cy][cx] = 3;
	return 0;
}
int fresh() {
	for (size_t y = 0; y < height; y++)
	{
		for (size_t x = 0; x < weight; x++)
		{
			if (sx == cx && sy == cy) {
				spwancake();
				score++;
				legth++;
			}
			if (y == 0 || y == height - 1) {
				map[y][x] = 4;
				life[y][x] = -1;
			}
			if (x == 0 || x == weight - 1) {
				map[y][x] = 4;
				life[y][x] = -1;
			}
			if (x == sx && y == sy) {
				map[y][x] = 1;
				life[y][x] = legth;
			}
			if (x == cx && y == cy) {
				map[y][x] = 3;
				life[y][x] = -1;
			}
			if (life[y][x] == 0) {
				map[y][x] = 0;
			}
			else if (life[y][x] == legth) {
				sx = x; sy = y;
				map[y][x] = 1;
				life[y][x]--;
			}
			else if(life[y][x]>0 && life[y][x]<legth) {
				map[y][x] = 2;
				life[y][x]--;
			}
			if (map[y][x] == 3) {
				cake = 1;
			}
			
		}
	}
	/*for (size_t y = 0; y < height; y++)
	{
		for (size_t x = 0; x < weight; x++)
		{
			if (y == 0 || y == height - 1) {
				map[y][x] = 4;
				life[y][x] = -1;
			}
			if (x == 0 || x == weight - 1) {
				map[y][x] = 4;
				life[y][x] = -1;
			}

		}

	}*/
	return 0;
}
int lifeadd() {
	for (size_t y = 0; y < height; y++)
	{
		for (size_t x = 0; x < weight; x++)
		{
			if (life[y][x] != 0) {
				life[y][x]++;
			}

		}
		
	}
	return 0;
}
int remove() {
	if (sx <= 0) {
		sx = weight - 2;
	}
	if (sx >= weight-1) {
		sx = 1;
	}
	if (sy <= 0) {
		sy = height - 2;
	}
	if (sy >= height-1) {
		sy = 1;
	}
	return 0;
}
int move() {
	int pre_key = key;//记录前一个按键的方向
	if (_kbhit())//如果用户按下了键盘中的某个键
	{
		fflush(stdin);//清空缓冲区的字符

		//getch()读取方向键的时候，会返回两次，第一次调用返回0或者224，第二次调用返回的才是实际值
		key = _getch();//第一次调用返回的不是实际值
		key = _getch();//第二次调用返回实际值
	}
	//蛇当前移动的方向不能和前一次的方向相反，比如蛇往左走的时候不能直接按右键往右走
	//如果当前移动方向和前一次方向相反的话，把当前移动的方向改为前一次的方向
	if (pre_key == 72 && key == 80)
		key = 72;
	if (pre_key == 80 && key == 72)
		key = 80;
	if (pre_key == 75 && key == 77)
		key = 75;
	if (pre_key == 77 && key == 75)
		key = 77;

	/**
	*控制台按键所代表的数字
	*“↑”：72
	*“↓”：80
	*“←”：75
	*“→”：77
	*/

	//判断蛇头应该往哪个方向移动
	switch (key)
	{
	case 75:
		sx--;//往左
		remove();
		break;
	case 77:
		sx++;
		remove();
		break;
	case 72:
		sy--;
		remove();
		break;
	case 80:
		sy++;//往下
		remove();
		
		break;
	}


	return 0;
}
int INIT() {

	map[height][weight] = 0;
	life[height][weight] = 0;
	map[height / 2][(weight / 2)] = 1;
	sx = weight / 2;
	sy = height / 2;
	life[height /2][(weight / 2)] = legth;
	map[height /2][(weight / 2)+1] = 2;
	life[height/2][(weight / 2) + 1] = 1;
	key = 75;
	spwancake();
	return 0;
}
int main() {
	HideCursor();
	INIT();
	while (!over) {
		move();
		isdead();
		
		fresh();
		print();
		
		Sleep(100);
		if (!cake) {
			spwancake();
		}
	}
	system("cls");
	gotoxy(40, 10);
	printf("Score:%d", score);
	gotoxy(40, 30);
	return 0;
}