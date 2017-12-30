#pragma once

#include "stdafx.h"
#include "Properties.h"

class Window
{
public:
	WCHAR szTitle[MAX_LOADSTRING];                  // The title bar text
	WCHAR szWindowClass[MAX_LOADSTRING];            // the main window class name

	BOOL InitInstance(HINSTANCE &hInst,HINSTANCE hInstance, int nCmdShow);
};